Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:54488 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbZCHTGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2009 15:06:38 -0400
Received: from mail-in-08-z2.arcor-online.net (mail-in-08-z2.arcor-online.net [151.189.8.20])
	by mx.arcor.de (Postfix) with ESMTP id 40B26332BAA
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2009 20:06:35 +0100 (CET)
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net [151.189.21.56])
	by mail-in-08-z2.arcor-online.net (Postfix) with ESMTP id 29F89213071
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2009 20:06:35 +0100 (CET)
Received: from webmail08.arcor-online.net (webmail08.arcor-online.net [151.189.8.44])
	by mail-in-16.arcor-online.net (Postfix) with ESMTP id 0BD892574AC
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2009 20:06:35 +0100 (CET)
Message-ID: <11673765.1236539194988.JavaMail.ngmail@webmail08.arcor-online.net>
Date: Sun, 8 Mar 2009 20:06:34 +0100 (CET)
From: schollsky@arcor.de
To: linux-media@vger.kernel.org
Subject: get_dvb_firmware after first review
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've browsed through the file and tried to get up to date download locations. The ones on linuxtv.org remain largely unchecked, I presume they're okay.

Comments at the right side are pretty much self-explanatory I hope. For two firmware files I could not find a valid download location, newer pages provide more recent versions here. What I did not check is wether the firmware is working or not - I plainly rely on correct filenames and proper checking routine insinde. 

Hope you find this useful by now.

Regards,

schollsky


#!/usr/bin/perl
#     DVB firmware extractor
#
#     (c) 2004 Andrew de Quincey
#
#     This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

use File::Temp qw/ tempdir /;
use IO::Handle;

@components = ( "sp8870", "sp887x", "tda10045", "tda10046",
		"tda10046lifeview", "av7110", "dec2000t", "dec2540t",
		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
		"opera1");

# Check args
syntax() if (scalar(@ARGV) != 1);
$cid = $ARGV[0];

# Do it!
for ($i=0; $i < scalar(@components); $i++) {
    if ($cid eq $components[$i]) {
	$outfile = eval($cid);
	die $@ if $@;
	print STDERR <<EOF;
Firmware $outfile extracted successfully.
Now copy it to either /usr/lib/hotplug/firmware or /lib/firmware
(depending on configuration of firmware hotplug).
EOF
	exit(0);
    }
}

# If we get here, it wasn't found
print STDERR "Unknown component \"$cid\"\n";
syntax();




# ---------------------------------------------------------------
# Firmware-specific extraction subroutines

sub sp8870 {
    my $sourcefile = "tt_Premium_217g.zip";					# updated, probably okay
    my $url = "http://www.technotrend.de/new/217g/$sourcefile";
    my $hash = "53970ec17a538945a6d8cb608a7b3899";
    my $outfile = "dvb-fe-sp8870.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    verify("$tmpdir/software/OEM/HE/App/boot/SC_MAIN.MC", $hash);
    copy("$tmpdir/software/OEM/HE/App/boot/SC_MAIN.MC", $outfile);

    $outfile;
}

sub sp887x {
    my $sourcefile = "Dvbt1.3.57.6.zip";					# Out of date, not updated, multiple updated drivers 
    my $url = "http://www.avermedia.com/software/$sourcefile";			# for different regions
    my $cabfile = "DVBT Net  Ver1.3.57.6/disk1/data1.cab";			# here: http://www.avermedia.com/avertv/Support/Download.aspx?Type=Software&id=417&tab=APDriver
    my $hash = "237938d53a7f834c05c42b894ca68ac3";
    my $outfile = "dvb-fe-sp887x.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();
    checkunshield();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    unshield("$tmpdir/$cabfile", $tmpdir);
    verify("$tmpdir/ZEnglish/sc_main.mc", $hash);
    copy("$tmpdir/ZEnglish/sc_main.mc", $outfile);

    $outfile;
}

sub tda10045 {
    my $sourcefile = "tt_budget_217g.zip";					# probably up to date
    my $url = "http://www.technotrend.de/new/217g/$sourcefile";
    my $hash = "2105fd5bf37842fbcdfa4bfd58f3594a";
    my $outfile = "dvb-fe-tda10045.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    extract("$tmpdir/software/OEM/PCI/App/ttlcdacc.dll", 0x37ef9, 30555, "$tmpdir/fwtmp");
    verify("$tmpdir/fwtmp", $hash);
    copy("$tmpdir/fwtmp", $outfile);

    $outfile;
}

sub tda10046 {
	my $sourcefile = "TT_PCI_2.19h_28_11_2006.zip";				# updated, probably okay
	my $url = "http://www.tt-download.com/download/updates/219/$sourcefile";
	my $hash = "6a7e1e2f2644b162ff0502367553c72d";
	my $outfile = "dvb-fe-tda10046.fw";
	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

	checkstandard();

	wgetfile($sourcefile, $url);
	unzip($sourcefile, $tmpdir);
	extract("$tmpdir/TT_PCI_2.19h_28_11_2006/software/OEM/PCI/App/ttlcdacc.dll", 0x65389, 24478, "$tmpdir/fwtmp");
	verify("$tmpdir/fwtmp", $hash);
	copy("$tmpdir/fwtmp", $outfile);

	$outfile;
}

sub tda10046lifeview {								# probably up to date
    my $sourcefile = "Drv_2.11.02.zip";
    my $url = "http://www.lifeview.com.tw/drivers/pci_card/FlyDVB-T/$sourcefile";
    my $hash = "1ea24dee4eea8fe971686981f34fd2e0";
    my $outfile = "dvb-fe-tda10046.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    extract("$tmpdir/LVHybrid.sys", 0x8b088, 24602, "$tmpdir/fwtmp");
    verify("$tmpdir/fwtmp", $hash);
    copy("$tmpdir/fwtmp", $outfile);

    $outfile;
}

sub av7110 {
    my $sourcefile = "dvb-ttpci-01.fw-261d";					# should be okay ;-)
    my $url = "http://www.linuxtv.org/downloads/firmware/$sourcefile";
    my $hash = "603431b6259715a8e88f376a53b64e2f";
    my $outfile = "dvb-ttpci-01.fw";

    checkstandard();

    wgetfile($sourcefile, $url);
    verify($sourcefile, $hash);
    copy($sourcefile, $outfile);

    $outfile;
}

sub dec2000t {									# probably up to date
    my $sourcefile = "dec217g.exe";
    my $url = "http://hauppauge.lightpath.net/de/$sourcefile";
    my $hash = "bd86f458cee4a8f0a8ce2d20c66215a9";
    my $outfile = "dvb-ttusb-dec-2000t.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    verify("$tmpdir/software/OEM/STB/App/Boot/STB_PC_T.bin", $hash);
    copy("$tmpdir/software/OEM/STB/App/Boot/STB_PC_T.bin", $outfile);

    $outfile;
}

sub dec2540t {									# probably up to date
    my $sourcefile = "dec217g.exe";
    my $url = "http://hauppauge.lightpath.net/de/$sourcefile";
    my $hash = "53e58f4f5b5c2930beee74a7681fed92";
    my $outfile = "dvb-ttusb-dec-2540t.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    verify("$tmpdir/software/OEM/STB/App/Boot/STB_PC_X.bin", $hash);
    copy("$tmpdir/software/OEM/STB/App/Boot/STB_PC_X.bin", $outfile);

    $outfile;
}

sub dec3000s {									# probably up to date
    my $sourcefile = "dec217g.exe";
    my $url = "http://hauppauge.lightpath.net/de/$sourcefile";
    my $hash = "b013ececea83f4d6d8d2a29ac7c1b448";
    my $outfile = "dvb-ttusb-dec-3000s.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    verify("$tmpdir/software/OEM/STB/App/Boot/STB_PC_S.bin", $hash);
    copy("$tmpdir/software/OEM/STB/App/Boot/STB_PC_S.bin", $outfile);

    $outfile;
}
sub opera1{									# Location of downloading???
	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);

	checkstandard();
	my $fwfile1="dvb-usb-opera1-fpga-01.fw";
	my $fwfile2="dvb-usb-opera-01.fw";
	extract("2830SCap2.sys", 0x62e8, 55024, "$tmpdir/opera1-fpga.fw");
	extract("2830SLoad2.sys",0x3178,0x3685-0x3178,"$tmpdir/fw1part1");
	extract("2830SLoad2.sys",0x0980,0x3150-0x0980,"$tmpdir/fw1part2");
	delzero("$tmpdir/fw1part1","$tmpdir/fw1part1-1");
	delzero("$tmpdir/fw1part2","$tmpdir/fw1part2-1");
	verify("$tmpdir/fw1part1-1","5e0909858fdf0b5b09ad48b9fe622e70");
	verify("$tmpdir/fw1part2-1","d6e146f321427e931df2c6fcadac37a1");
	verify("$tmpdir/opera1-fpga.fw","0f8133f5e9051f5f3c1928f7e5a1b07d");

	my $RES1="\x01\x92\x7f\x00\x01\x00";
	my $RES0="\x01\x92\x7f\x00\x00\x00";
	my $DAT1="\x01\x00\xe6\x00\x01\x00";
	my $DAT0="\x01\x00\xe6\x00\x00\x00";
	open FW,">$tmpdir/opera.fw";
	print FW "$RES1";
	print FW "$DAT1";
	print FW "$RES1";
	print FW "$DAT1";
	appendfile(FW,"$tmpdir/fw1part1-1");
	print FW "$RES0";
	print FW "$DAT0";
	print FW "$RES1";
	print FW "$DAT1";
	appendfile(FW,"$tmpdir/fw1part2-1");
	print FW "$RES1";
	print FW "$DAT1";
	print FW "$RES0";
	print FW "$DAT0";
	copy ("$tmpdir/opera1-fpga.fw",$fwfile1);
	copy ("$tmpdir/opera.fw",$fwfile2);

	$fwfile1.",".$fwfile2;
}

sub vp7041 {									# Out of date, not updated, new driver page here:
    my $sourcefile = "2.422.zip";						# http://www.twinhan.com/download_driver&software.asp
    my $url = "http://www.twinhan.com/files/driver/USB-Ter/$sourcefile";
    my $hash = "e88c9372d1f66609a3e7b072c53fbcfe";
    my $outfile = "dvb-vp7041-2.422.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    extract("$tmpdir/VisionDTV/Drivers/Win2K&XP/UDTTload.sys", 12503, 3036, "$tmpdir/fwtmp1");
    extract("$tmpdir/VisionDTV/Drivers/Win2K&XP/UDTTload.sys", 2207, 10274, "$tmpdir/fwtmp2");

    my $CMD = "\000\001\000\222\177\000";
    my $PAD = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000";
    my ($FW);
    open $FW, ">$tmpdir/fwtmp3";
    print $FW "$CMD\001$PAD";
    print $FW "$CMD\001$PAD";
    appendfile($FW, "$tmpdir/fwtmp1");
    print $FW "$CMD\000$PAD";
    print $FW "$CMD\001$PAD";
    appendfile($FW, "$tmpdir/fwtmp2");
    print $FW "$CMD\001$PAD";
    print $FW "$CMD\000$PAD";
    close($FW);

    verify("$tmpdir/fwtmp3", $hash);
    copy("$tmpdir/fwtmp3", $outfile);

    $outfile;
}

sub dibusb {
	my $url = "http://www.linuxtv.org/downloads/firmware/dvb-usb-dibusb-5.0.0.11.fw";	# should be okay ;-)
	my $outfile = "dvb-dibusb-5.0.0.11.fw";
	my $hash = "fa490295a527360ca16dcdf3224ca243";

	checkstandard();

	wgetfile($outfile, $url);
	verify($outfile,$hash);

	$outfile;
}

sub nxt2002 {
    my $sourcefile = "Technisat_DVB-PC_4_4_COMPACT.zip";					# out of date, not updated, new driver 
    my $url = "http://www.bbti.us/download/windows/$sourcefile";				# page here: http://www.bbti.us/support.htm
    my $hash = "476befae8c7c1bb9648954060b1eec1f";
    my $outfile = "dvb-fe-nxt2002.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    verify("$tmpdir/SkyNET.sys", $hash);
    extract("$tmpdir/SkyNET.sys", 331624, 5908, $outfile);

    $outfile;
}

sub nxt2004 {
    my $sourcefile = "AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip";					# probably up to date
    my $url = "http://www.aver.com/support/Drivers/$sourcefile";
    my $hash = "111cb885b1e009188346d72acfed024c";
    my $outfile = "dvb-fe-nxt2004.fw";
    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

    checkstandard();

    wgetfile($sourcefile, $url);
    unzip($sourcefile, $tmpdir);
    verify("$tmpdir/3xHybrid.sys", $hash);
    extract("$tmpdir/3xHybrid.sys", 465304, 9584, $outfile);

    $outfile;
}

sub or51211 {											# should be okay ;-)
    my $fwfile = "dvb-fe-or51211.fw";
    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
    my $hash = "d830949c771a289505bf9eafc225d491";

    checkstandard();

    wgetfile($fwfile, $url);
    verify($fwfile, $hash);

    $fwfile;
}

sub or51132_qam {										# should be okay ;-)
    my $fwfile = "dvb-fe-or51132-qam.fw";
    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
    my $hash = "7702e8938612de46ccadfe9b413cb3b5";

    checkstandard();

    wgetfile($fwfile, $url);
    verify($fwfile, $hash);

    $fwfile;
}

sub or51132_vsb {										# should be okay ;-)
    my $fwfile = "dvb-fe-or51132-vsb.fw";
    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
    my $hash = "c16208e02f36fc439a557ad4c613364a";

    checkstandard();

    wgetfile($fwfile, $url);
    verify($fwfile, $hash);

    $fwfile;
}

sub bluebird {											# should be okay ;-)
	my $url = "http://www.linuxtv.org/download/dvb/firmware/dvb-usb-bluebird-01.fw";
	my $outfile = "dvb-usb-bluebird-01.fw";
	my $hash = "658397cb9eba9101af9031302671f49d";

	checkstandard();

	wgetfile($outfile, $url);
	verify($outfile,$hash);

	$outfile;
}

# ---------------------------------------------------------------
# Utilities

sub checkstandard {
    if (system("which unzip > /dev/null 2>&1")) {
	die "This firmware requires the unzip command - see ftp://ftp.info-zip.org/pub/infozip/UnZip.html\n";
    }
    if (system("which md5sum > /dev/null 2>&1")) {
	die "This firmware requires the md5sum command - see http://www.gnu.org/software/coreutils/\n";
    }
    if (system("which wget > /dev/null 2>&1")) {
	die "This firmware requires the wget command - see http://wget.sunsite.dk/\n";
    }
}

sub checkunshield {
    if (system("which unshield > /dev/null 2>&1")) {
	die "This firmware requires the unshield command - see http://sourceforge.net/projects/synce/\n";
    }
}

sub wgetfile {
    my ($sourcefile, $url) = @_;

    if (! -f $sourcefile) {
	system("wget -O \"$sourcefile\" \"$url\"") and die "wget failed - unable to download firmware";
    }
}

sub unzip {
    my ($sourcefile, $todir) = @_;

    $status = system("unzip -q -o -d \"$todir\" \"$sourcefile\" 2>/dev/null" );
    if ((($status >> 8) > 2) || (($status & 0xff) != 0)) {
	die ("unzip failed - unable to extract firmware");
    }
}

sub unshield {
    my ($sourcefile, $todir) = @_;

    system("unshield x -d \"$todir\" \"$sourcefile\" > /dev/null" ) and die ("unshield failed - unable to extract firmware");
}

sub verify {
    my ($filename, $hash) = @_;
    my ($testhash);

    open(CMD, "md5sum \"$filename\"|");
    $testhash = <CMD>;
    $testhash =~ /([a-zA-Z0-9]*)/;
    $testhash = $1;
    close CMD;
    die "Hash of extracted file does not match!\n" if ($testhash ne $hash);
}

sub copy {
    my ($from, $to) = @_;

    system("cp -f \"$from\" \"$to\"") and die ("cp failed");
}

sub extract {
    my ($infile, $offset, $length, $outfile) = @_;
    my ($chunklength, $buf, $rcount);

    open INFILE, "<$infile";
    open OUTFILE, ">$outfile";
    sysseek(INFILE, $offset, SEEK_SET);
    while($length > 0) {
	# Calc chunk size
	$chunklength = 2048;
	$chunklength = $length if ($chunklength > $length);

	$rcount = sysread(INFILE, $buf, $chunklength);
	die "Ran out of data\n" if ($rcount != $chunklength);
	syswrite(OUTFILE, $buf);
	$length -= $rcount;
    }
    close INFILE;
    close OUTFILE;
}

sub appendfile {
    my ($FH, $infile) = @_;
    my ($buf);

    open INFILE, "<$infile";
    while(1) {
	$rcount = sysread(INFILE, $buf, 2048);
	last if ($rcount == 0);
	print $FH $buf;
    }
    close(INFILE);
}

sub delzero{
	my ($infile,$outfile) =@_;

	open INFILE,"<$infile";
	open OUTFILE,">$outfile";
	while (1){
		$rcount=sysread(INFILE,$buf,22);
		$len=ord(substr($buf,0,1));
		print OUTFILE substr($buf,0,1);
		print OUTFILE substr($buf,2,$len+3);
	last if ($rcount<1);
	printf OUTFILE "%c",0;
#print $len." ".length($buf)."\n";

	}
	close(INFILE);
	close(OUTFILE);
}

sub syntax() {
    print STDERR "syntax: get_dvb_firmware <component>\n";
    print STDERR "Supported components:\n";
    for($i=0; $i < scalar(@components); $i++) {
	print STDERR "\t" . $components[$i] . "\n";
    }
    exit(1);
}
