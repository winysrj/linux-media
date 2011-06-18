Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:49273 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751332Ab1FRRUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 13:20:50 -0400
Message-ID: <4DFCDE6D.8090008@hoogenraad.net>
Date: Sat, 18 Jun 2011 19:20:45 +0200
From: Jan Hoogenraad <jan-verisign@hoogenraad.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: change in build .sh due to Pulseaudio device removal /
References: <4DFBB431.60101@redhat.com>
In-Reply-To: <4DFBB431.60101@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------030304030803060108040102"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------030304030803060108040102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mauro:

The change in build.sh
http://git.linuxtv.org/media_build.git?a=commitdiff;h=16cf0606fd59484236356e400a89c083e76da64b

now requires installation of a Perl package Proc::ProcessTable  that is 
not present in standard Ubuntu systems.

I needed to run
  sudo aptitude install libproc-processtable-perl
before I could continue after the change.

Is there a way around this ?


Mauro Carvalho Chehab wrote:
> During a long time, the removal of an alsa drivers were a problem
> for me, and other developers reported to have the same problem.
>
> With Hans de Goede help, I've got the pulseaudio syntax that allows
> releasing an alsa device. With that, I've added a patch to the media
> build that will automatically handle it, when "make rmmod" is
> called.
>
> Feel free to test and give some feedback. I suspect that the logic
> will need more hacks, as pulseaudio-libs is not capable of detecting
> the name of some USB alsa drivers.
>
> The logic there is not optimized: It is basically running pacmd list-sources
> and pacmd list-sinks several times, as I didn't have time yet to optimize.
> I'll probably do it soon, after finishing some other things.
>
> Enjoy!
> Mauro.
>
>
>> From 16cf0606fd59484236356e400a89c083e76da64b Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab<mchehab@redhat.com>
> Date: Fri, 17 Jun 2011 16:48:04 -0300
> Subject: [PATCH] rmmod.pl: Add a logic to allow removing audio modules with pulseaudio
>
> Pulseaudio keeps audio devices opened forever. In order to be able to
> remove a device, pulseaudio needs to de-allocate the device.
>
> Unfortunately, pulseaudio recognizes alsa drivers as "module"
> (an integer number, not related to the device nodename), and only
> allows module removal if running with user matches the console owner.
>
> The logic inside rmmod.pl will now take the above into account. So,
> it will detect if pulseaudio is running. If it is, it will:
>
> 1) list the pulseaudio modules with "pacmd list-sinks"
>     and "pacmd list-sources"
>
> 2) detect if any of the modules there is provided by a v4l device;
>
> 3) If they're provided by a video device, it removes the module with:
> 	pactl unload-module 26
>
> Even the above logic is not perfect as, due to a pulseaudio libs bug,
> pulseaudio can't detect the name of em28xx-alsa driver, as it uses the
> same interface as the video node. Similar hacks will may be needed
> for other USB devices, like tm6000 and cx231xx.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> diff --git a/build.sh b/build.sh
> index 60d0c26..3cc21f8 100755
> --- a/build.sh
> +++ b/build.sh
> @@ -12,6 +12,8 @@ echo "Checking if the needed tools are present"
>   run ./check_needs.pl
>   echo "Checking for Digest::SHA1 (package perl-Digest-SHA1)"
>   run perl -MDigest::SHA1 -e 1
> +echo "Checking for Proc::ProcessTable (package perl-Proc-ProcessTable)"
> +run perl -MProc::ProcessTable -e 1
>   echo
>   echo "************************************************************"
>   echo "* This script will download the latest tarball and build it*"
> diff --git a/v4l/scripts/rmmod.pl b/v4l/scripts/rmmod.pl
> index ed79cbe..53ea451 100755
> --- a/v4l/scripts/rmmod.pl
> +++ b/v4l/scripts/rmmod.pl
> @@ -1,6 +1,8 @@
>   #!/usr/bin/perl
>   use strict;
>   use File::Find;
> +use Proc::ProcessTable;
> +
>
>   my %depend = ();
>   my %depend2 = ();
> @@ -166,6 +168,69 @@ sub insmod ($)
>   	}
>   }
>
> +my @pulse;
> +my $try_pulseaudio = 1;
> +
> +sub check_pulseaudio()
> +{
> +	my $t = new Proc::ProcessTable;
> +	foreach my $p ( @{$t->table} ) {
> +		push @pulse, $p->uid if ($p->cmndline =~m,/pulseaudio ,);
> +	}
> +	$try_pulseaudio = 0 if (!@pulse);
> +
> +	print "Pulseaudio is running with UUID(s): @pulse\n";
> +}
> +
> +sub unload_pulseaudio($)
> +{
> +	my $driver_name = shift;
> +	my $cur_module;
> +
> +	return if (!$try_pulseaudio);
> +
> +	check_pulseaudio() if (!@pulse);
> +	return if (!$try_pulseaudio);
> +
> +	for my $pid (@pulse) {
> +#		printf "LANG=C sudo -u \\\#$pid pacmd list-sources |\n";
> +		open IN, "LANG=C sudo -u \\\#$pid pacmd list-sources |";
> +		while (<IN>) {
> +			$cur_module = $1 if (/^\s*module:\s*(\d+)/);
> +
> +			if (/^\s*alsa.driver_name\s*=\s*"(.*)"/) {
> +				if ($1 eq $driver_name) {
> +					print "LANG=C sudo -u \\#$pid pactl unload-module $cur_module\n";
> +					system ("LANG=C sudo -u \\#$pid pactl unload-module $cur_module");
> +				}
> +				next;
> +			}
> +
> +			# Special case: em28xx sometimes use a Vendor Class at
> +			# the same interface as the video node. Pulseaudio can't
> +			# get the driver name in this case
> +			if (/^\s*alsa.card_name\s*=\s*"Em28xx/) {
> +				print "LANG=C sudo -u \\#$pid pactl unload-module $cur_module\n";
> +				system ("LANG=C sudo -u \\#$pid pactl unload-module $cur_module");
> +			}
> +		}
> +		close IN;
> +
> +#		printf "LANG=C sudo -u \\\#$pid pacmd list-sinks |\n";
> +		open IN, "LANG=C sudo -u \\#$pid pacmd list-sinks |" or return;
> +		while (<IN>) {
> +			$cur_module = $1 if (/^\s*module:\s*(\d+)/);
> +			if (/^\s*alsa.driver_name\s*=\s*"(.*)"/) {
> +				if ($1 eq $driver_name) {
> +					print "LANG=C sudo -u \\#$pid pactl unload-module $1\n";
> +					system ("LANG=C sudo -u \\#$pid pactl unload-module $1");
> +				}
> +			}
> +		}
> +	}
> +	close IN;
> +}
> +
>   sub rmmod(@)
>   {
>   	my $rmmod = findprog('rmmod');
> @@ -173,8 +238,10 @@ sub rmmod(@)
>   	foreach (reverse @_) {
>   		s/-/_/g;
>   		if (exists ($loaded{$_})) {
> -			print "$rmmod $_\n";
> -			unshift @not, $_ if (system "$rmmod $_");
> +			my $module = $_;
> +			print "$rmmod $module\n";
> +			unload_pulseaudio($module);
> +			unshift @not, $module if (system "$rmmod $module");
>   		}
>   	}
>   	return @not;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--------------030304030803060108040102
Content-Type: text/x-vcard; charset=utf-8;
 name="jan-verisign.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jan-verisign.vcf"

begin:vcard
fn:Jan Hoogenraad
n:Hoogenraad;Jan
org:Hoogenraad Interface Services
adr;quoted-printable;dom:;;Postbus 2717;Utrecht;;-- =
	=0D=0A=
	Jan Hoogenraad=0D=0A=
	Hoogenraad Interface Services=0D=0A=
	Postbus 2717=0D=0A=
	3500 GS
email;internet:jan-verisign@hoogenraad.net
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------030304030803060108040102--
