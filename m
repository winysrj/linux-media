Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63948 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaH1SZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 14:25:46 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so1365742wid.7
        for <linux-media@vger.kernel.org>; Thu, 28 Aug 2014 11:25:45 -0700 (PDT)
Received: from x220.optiplex-networks.com (81-178-2-118.dsl.pipex.com. [81.178.2.118])
        by mx.google.com with ESMTPSA id lu12sm38249519wic.4.2014.08.28.11.25.43
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Aug 2014 11:25:44 -0700 (PDT)
Message-ID: <53FF7425.9050106@gmail.com>
Date: Thu, 28 Aug 2014 19:25:41 +0100
From: Kaya Saman <kayasaman@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV-HVR 1900 high BER and unable to switch to Composite
 input
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[p.s. sorry if this appears twice, I tried attaching the log output 
files but not sure if the list software allows that, so have added to 
Dropbox instead]


checking the wiki the WinTV HVR-1900 is suggested as supported:

http://www.linuxtv.org/wiki/index.php/Pvrusb2

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1950

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1900


I am running Arch Linux with Kernel 3.16.1-6 and all other libraries and 
packages up to date as of writing this posting.

For some reason I am experiencing a quite high BER on the DVB-T tuner 
side and also I'm unable to switch to the "composite" input for most of 
the time. On some rare occasions the RCA input works but very rarely.

I have read a similar posting to my issues:

http://www.isely.net/pipermail/pvrusb2/2009-October/002646.html


The kernel and daemon output logs are attached.

[EDIT] 
https://www.dropbox.com/sh/z3h7b1kctma9kh4/AAB_n_bi4EP1v86M0546-7Vka?dl=0

Having attempted to test out MythTV and TVHeadend, both work fine with 
the DVB-T portion but have issues switching to the analog inputs. TVH in 
particular keeps claiming "no MPEG encoder found", when the card does 
have an MPEG2 encoder. MythTV says either "permission denied" or "unable 
to connect"?


Running cat /dev/video0 > outputfile.avi does work however, the output 
is just a black screen with a colored line bar flickering at the bottom 
of the video space?


All suggested firmware files have been installed and loaded though the 
logs suggest something wrong with the pvrusb2 driver?


Would anybody be able to help?


Thanks.


Kaya
