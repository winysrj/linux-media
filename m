Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta.bitpro.no ([92.42.64.202]:35792 "EHLO mta.bitpro.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3HRPVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 11:21:55 -0400
Message-ID: <5210E6DD.7090008@bitfrost.no>
Date: Sun, 18 Aug 2013 17:23:09 +0200
From: Hans Petter Selasky <hps@bitfrost.no>
MIME-Version: 1.0
To: Ulf <mopp@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
In-Reply-To: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/13 17:00, Ulf wrote:
> Hi,
>
>> It is DVB-S driver. HVR-900 is DVB-T and DVB-C.
> The si2168 is a DVB-T2, DVB-T, and DVB-C demodulator http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2168-A20-short.pdf.
>
> I tried to apply the dvbsky-linux-3.9-hps-v2.diff to media_build.git (used do_patches.sh from http://www.selasky.org/hans_petter/distfiles/webcamd-3.10.0.7.tar.bz2), but I was not able to compile it. I already changed some includes, but then I got the next error.
> I just wanted to test if the si2168 module will work with si2165, but as I don't expect it to work I stopped trying to compile the si2168.

Hi,

You need to replace the "media_tree" with a symbolic link to a real 
media_tree. Then it will work! The sources provided with webcamd are 
simply minimal.

There is a file called "sources.txt":

Media tree sources used:
========================

git clone git://linuxtv.org/media_tree.git
git checkout remotes/origin/master

top commit dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d


Else you could install FreeBSD in VirtualBox or something like that and 
test.

Package is here:

http://www.freshports.org/multimedia/webcamd/

--HPS
