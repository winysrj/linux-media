Return-path: <linux-media-owner@vger.kernel.org>
Received: from www52.your-server.de ([213.133.104.52]:32772 "EHLO
	www52.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2I3TX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Sep 2012 15:23:29 -0400
Received: from [78.46.4.229] (helo=sslproxy03.your-server.de)
	by www52.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.74)
	(envelope-from <martin.burnicki@burnicki.net>)
	id 1TIOdF-0005tu-Ow
	for linux-media@vger.kernel.org; Sun, 30 Sep 2012 20:52:49 +0200
Received: from [77.20.80.167] (helo=pc-martin)
	by sslproxy03.your-server.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <martin.burnicki@burnicki.net>)
	id 1TIOZm-0001kI-Ko
	for linux-media@vger.kernel.org; Sun, 30 Sep 2012 20:49:14 +0200
From: Martin Burnicki <martin.burnicki@burnicki.net>
To: linux-media@vger.kernel.org
Subject: Current media_build doesn't succeed building on kernel 3.1.10
Date: Sun, 30 Sep 2012 20:52:42 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201209302052.42723.martin.burnicki@burnicki.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

is anybody out there who can help me with the media_build system? I'm trying 
to build the current modules on an openSUSE 12.1 system (kernel 3.1.10, 
x86_64), but I'm getting compilation errors because the s5k4ecgx driver uses 
function devm_regulator_bulk_get() which AFAICS has been introduced in kernel 
3.4 only. When I run the ./build script compilation stops with these 
messages:

 CC [M]  /root/projects/media_build/v4l/s5k4ecgx.o
media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_load_firmware':
media_build/v4l/s5k4ecgx.c:346:2: warning: format '%d' expects argument of \
    type 'int', but argument 4 has type 'size_t' [-Wformat]
media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_probe':
media_build/v4l/s5k4ecgx.c:977:2: error: implicit declaration of \
    function 'devm_regulator_bulk_get' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors


Probably I'll don't need module s5k4ecgx anyway, so any hint how to exclude 
this from build would be fine.

On this page 
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers#Retrieving_and_Building.2FCompiling_the_Latest_V4L-DVB_Source_Code
the section "More Manually Intensive Approach" mentions steps where I can 
run "make menuconfig" after unpacking the sources and before the build 
process is started, so I could deselect the module(s) I don't need and 
exclude them from build. However, I've no idea what I should use for "DIR=" 
in the command 

  make tar DIR=<some dir with media -git tree>

mentioned on the web page.

According to theis link
https://patchwork.kernel.org/patch/1267511/
the s5k4ecgx module which does not build here has just been added at the 
beginning of August, so if I could specify a git version of the code which is 
slightly older this might also work.

BTW, if I understand the build environment correctly then there should be 
dayly test builds of the package for varions kernels. I'd expect those 
automated builds should also fail for kernels older than 3.4.


Regards,

Martin
