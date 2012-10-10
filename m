Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:42493 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab2JJNj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:39:29 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Aapo Tahkola <aet@rasterburn.org>, CityK <cityk@rogers.com>
Subject: [PATCH 1/5] contrib: add some scripts to extract m920x firmwares from USB dumps
Date: Wed, 10 Oct 2012 15:39:18 +0200
Message-Id: <1349876363-12098-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
References: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aapo Tahkola <aet@rasterburn.org>

Signed-off-by: Aapo Tahkola <aet@rasterburn.org>
---
 contrib/m920x/m920x_parse.pl       |  277 ++++++++++++++++++++++++++++++++++++
 contrib/m920x/m920x_sp_firmware.pl |  115 +++++++++++++++
 2 files changed, 392 insertions(+)
 create mode 100755 contrib/m920x/m920x_parse.pl
 create mode 100755 contrib/m920x/m920x_sp_firmware.pl

diff --git a/contrib/m920x/m920x_parse.pl b/contrib/m920x/m920x_parse.pl
new file mode 100755
index 0000000..135ed5a
--- /dev/null
+++ b/contrib/m920x/m920x_parse.pl
@@ -0,0 +1,277 @@
+#!/usr/bin/perl
+#
+# This ULi M920x specific script processes usbsnoop log files (as well as those which have been parsed by mrec's parser.pl utility).
+# Taken from http://www.linuxtv.org/wiki/index.php/ULi_M920x_parse
+
+use Getopt::Std;
+
+sub expand_string {
+	my @arr = ();
+	my ($str) = @_;
+
+	if (length($str) == 8) {
+		push(@arr, substr($str, 0, 2));
+		push(@arr, substr($str, 2, 2));
+		push(@arr, substr($str, 4, 2));
+		push(@arr, substr($str, 6, 2));
+	}elsif(length($str) == 4) {
+		push(@arr, substr($str, 0, 2));
+		push(@arr, substr($str, 2, 2));
+	}elsif(length($str) == 2) {
+		push(@arr, $str);
+	}elsif(length($str) == 1) {
+		return;
+	}
+	return @arr;
+}
+
+sub expand_string_long {
+	my @bytes = ();
+	my (@str) = @_;
+
+	foreach(@str) {
+		#@arr = expand_string($_);
+		#foreach(@arr){
+		#	push(@bytes, $_);
+		#}
+		@bytes = ( @bytes, expand_string($_) );
+	}
+
+	return @bytes;
+}
+
+sub print_array_bytes {
+	my (@str) = @_;
+
+	foreach(expand_string_long(@str)){
+		print "$_ ";
+	}
+}
+
+sub print_bytes {
+	my ($str) = @_;
+
+	print_array_bytes(split(/ /, $str));
+}
+
+sub check {
+	my ($cmd, @bytes) = @_;
+	my @cmp;
+	my $i;
+	#print "cmd <$cmd>\n";
+	my $fail = 0;
+
+	@cmp = split(/ /, $cmd);
+	for ($i = 0; $i < scalar(@cmp); $i++) {
+		#print "check $bytes[$i] vs $cmp[$i]\n";
+		if ($cmp[$i] == "-1") {
+			next;
+		}
+
+		if (not($bytes[$i] =~ m/$cmp[$i]/)) {
+			$fail = 1;
+			print "($bytes[$i]!=$cmp[$i], $i)";
+		}
+	}
+	if ($fail) {
+		print "\n";
+		print_array_bytes(@bytes);
+		print "\n$cmd\n";
+	}
+}
+
+sub get_line {
+	my ($cmd) = @_; # xxx: could be more flexible
+	my @ret;
+	my @cmp;
+	my $i;
+
+	again:
+	while($line = <STDIN>) {
+		#001295:  OUT: 000002 ms 135775 ms 40 23 c0 00 80 00 00 00 >>>
+		if($input eq "us" && $line =~ m/\S+:  \S+: \S+ ms \S+ ms ([a-fA-F0-9 ]+)/) {
+			@ret = split(/ /, $1); $foo = $1;
+			@ret[2,3,4,5,6,7] = @ret[3,2,5,4,7,6];
+			last;
+		}
+
+		if($input eq "um" && $line =~ m/\S+ \S+ \S+ \S+ s ([a-fA-F0-9 ]+)/) {
+			@ret = expand_string_long(split(/ /, $1)); $foo = $1;
+			last;
+		}
+	}
+	@cmp = split(/ /, $cmd);
+	for ($i = 0; $i < scalar(@cmp); $i++) {
+		if ($cmp[$i] == "-1") {
+			next;
+		}
+
+		if (not($cmp[$i] eq $ret[$i])) {
+			#print "fail\n";
+			goto again;
+		}
+	}
+
+	return @ret;
+}
+
+sub us_get_write {
+	#print "<$line>\n";
+	if($input == "us" && $line =~ m/>>>\s+([a-fA-F0-9 ]+)/) {
+		return split(/ /, $1);
+	}
+	if($input == "um") {
+		if($line =~ m/\S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ = ([a-fA-F0-9 ]+)/) {
+			#print "read match $line\n";
+			return expand_string_long(split(/ /, $1));
+		}
+	}
+}
+
+sub get_read {
+	#print "<$line>\n";
+	if($input == "us" && $line =~ m/<<<  ([a-fA-F0-9 ]+)/) {
+		return split(/ /, $1);
+	}
+	if($input == "um") {
+		while($line = <STDIN>) {
+			if($line =~ m/\S+ \S+ \S+ \S+ \S+ \S+ = ([a-fA-F0-9 ]+)/) {
+				return expand_string_long(split(/ /, $1));
+			}
+
+		}
+	}
+}
+
+sub usage {
+	print STDERR << "EOF";
+
+	-i	um (usbmon)
+		us (usb snoop)
+		sp (snoopy pro)
+
+	-m	fw (extract firmware)
+		i2c (show i2c traffic)
+EOF
+exit;
+}
+
+getopts("m:i:", \%opt ) or usage();
+
+$mode = $opt{m};
+$input = $opt{i};
+
+if ($input != "um" && $input != "us" && $input != "sp") {
+	usage();
+}
+
+if ($mode != "fw" && $mode != "i2c") {
+	usage();
+}
+
+if ($mode eq "fw") {
+	open(out, ">fw") || die "Can't open fw";
+
+	while(@bytes = get_line()) {
+		if(scalar(@bytes) <= 1) {
+			last;
+		}
+
+		$len = hex($bytes[6] . $bytes[7]);
+		if ($len < 32) {
+			next;
+		}
+
+		@fw_bytes = us_get_write();
+		if ($len != scalar(@fw_bytes)) {
+			#note: usbmon will not log bulk writes longer than 32 bytes by default
+			print "bulk size doesn't match! Check usbmon.\n";
+			print $len . " != " . scalar(@fw_bytes) . "\n";
+			exit(0);
+		}
+		print out pack("v", hex($bytes[2] . $bytes[3]));
+		print out pack("v", hex($bytes[4] . $bytes[5]));
+		print out pack("v", scalar(@fw_bytes));
+
+		foreach(@fw_bytes) {
+			print out pack("C", hex($_));
+		}
+	}
+	exit(1);
+}
+
+while(@bytes = get_line("-1")) {
+	if(scalar(@bytes) <= 1) {
+		last;
+	}
+
+	$master_line = $. - 1;
+
+	if ($bytes[0] == "40" && $bytes[1] == "23") {
+
+		if ($bytes[4] == "80" || $bytes[4] == "00") {
+			my $multibyte = 0;
+			my $addr;
+
+			$addr = $bytes[2];
+
+			printf "%06d: ", $master_line;
+			print "addr $addr ";
+
+			if (hex($addr) & 0x1) {
+				print "Invalid address\n";
+			}
+
+			@bytes = get_line("40 23");
+
+			$reg = $bytes[2];
+			if ($bytes[4] == "80") {
+				$multibyte = 1;
+			} else {
+				@bytes = get_line("40 23");
+			}
+			#if ($bytes[4] != "40") {
+			#	print "(missing 40)";
+			#}
+
+			if ($bytes[4] == "80") {
+				if ($multibyte == 0) {
+					$raddr = sprintf("%02x", hex($addr) | 0x1);
+
+					check("40 23 $raddr 00 80 00 00 00", @bytes);
+
+					@bytes = get_line("c0 23");
+					print "reg $reg = ";
+				} else {
+					print "$reg = ";
+					@bytes = get_line("c0 23");
+					while ($bytes[4] == "21") {
+						check("c0 23 00 00 21 00 -1 -1", @bytes);
+
+						@bytes = get_read();
+						print_array_bytes(@bytes);
+
+						@bytes = get_line("c0 23");
+					}
+				}
+
+				check("c0 23 -1 00 60 00 -1 -1", @bytes);
+
+				@bytes = get_read();
+				print_array_bytes(@bytes);
+				print "read\n";
+
+			} else {
+				check("40 23 -1 00 4|00 00 00 00", @bytes);
+				print "reg $reg = $bytes[2]";
+
+				while ($bytes[4] != "40") {
+					@bytes = get_line("40 23");
+					check("40 23 -1 00 4|00 00 00 00", @bytes);
+					print " $bytes[2]";
+				}
+				print "\n";
+			}
+		}
+	}
+}
diff --git a/contrib/m920x/m920x_sp_firmware.pl b/contrib/m920x/m920x_sp_firmware.pl
new file mode 100755
index 0000000..3c1f0fd
--- /dev/null
+++ b/contrib/m920x/m920x_sp_firmware.pl
@@ -0,0 +1,115 @@
+#!/usr/bin/perl
+#
+# This script converts the output from SnoopyPro's log window into a M920x driver compatible binary form.
+# Taken from http://www.linuxtv.org/wiki/index.php/ULi_M920x_sp_firmware
+
+sub get_line {
+
+
+	while($line = <STDIN>) {
+		if($line =~ m/\S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+/) {
+			#print "returning line $line";
+			return $line;
+		}else{
+			#print "not matched $line\n";
+		}
+	}
+
+	#exit;
+}
+
+sub get_line_read {
+
+	while($line = <STDIN>) {
+
+		#d5748560 78669980 C Ci:004:00 0 1 = 50
+		#d3ea8260 44357030 C Ci:004:00 0 1 = bc
+		if($line =~ m/\S+ \S+ C \S+ \S+ (\S+) = (\S+)/) {
+			return $2;
+		}else{
+			#print "not matched $line\n";
+		}
+	}
+
+}
+
+$linenum = 0;
+sub get_tf_data {
+	$full = "";
+
+	$line = <STDIN>; $linenum++;
+	while($line =~ m/^\S\S\S\S: (.+)/) {
+		$full .= $1;
+		#print "$1";
+		$line = <STDIN>; $linenum++;
+	}
+	return $full;
+}
+
+open(out,">fw") || die "Can't open fw";
+
+sub write_bytes {
+	my($str) = @_;
+
+	#print "ds $str sd\n";
+
+	@bytes = split(/ /, $str);
+	foreach(@bytes){
+		#print "$_\n";
+		print out pack("C", hex($_));
+	}
+
+	#exit(1);
+}
+
+sub to_words {
+	my($str) = @_;
+
+	print "ds $str sd\n";
+
+	@bytes = split(/\S+ \S+/, $str);
+	foreach(@bytes){
+		print "$_\n";
+		print out pack("v", hex($_));
+	}
+
+	exit(1);
+}
+
+while($line = <STDIN>) { $linenum++;
+
+	if($line =~ m/SetupPacket:/) {
+		$setup_linenum = $linenum;
+		$setup = get_tf_data();
+
+		#to_words($setup);
+
+		#write_bytes($setup);
+
+		#print "$line\n";
+
+		while($line = <STDIN>) { $linenum++;
+			if($line =~ m/TransferBuffer: 0x00000040/) {
+				#print "$setup, $setup_linenum\n";
+
+				@bytes = split(/ /, $setup);
+				print out pack("v", hex($bytes[3] . $bytes[2]));
+				print out pack("v", hex($bytes[5] . $bytes[4]));
+				print out pack("v", hex("0x40"));
+
+				$lid = get_tf_data();
+				write_bytes($lid);
+				#print $lid;
+				#print "\n";
+
+				last;
+			}elsif($line =~ m/No TransferBuffer/) {
+				last;
+			}elsif($line =~ m/TransferBuffer:/) {
+				last;
+			}
+
+		}
+	}
+
+}
-- 
1.7.10.4

