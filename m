Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755567AbZAORcM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 12:32:12 -0500
Message-ID: <496F7324.4050608@gmx.de>
Date: Thu, 15 Jan 2009 18:32:20 +0100
From: Bastian Beekes <bastian.beekes@gmx.de>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: MSI DigiVox A/D II
References: <S1755369AbZAMWYU/20090113222421Z+45@vger.kernel.org>	 <496D1C18.3010403@gmx.de>	 <412bdbff0901131502g12d62917ka4fbebf7b74c6579@mail.gmail.com>	 <496D1F1B.8080801@gmx.de> <412bdbff0901131516p44867478jdef953d0e8ccab66@mail.gmail.com>
In-Reply-To: <412bdbff0901131516p44867478jdef953d0e8ccab66@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hm,

now I installed the Intrepid Kernel via
echo 'deb http://archive.ubuntu.com/ubuntu/ intrepid main restricted' | 
sudo tee /etc/apt/sources.list.d/intrepid-kernel.list && sudo apt-get 
update && sudo apt-get -y install linux linux-generic 
linux-headers-generic linux-image-generic 
linux-restricted-modules-generic && sudo rm 
/etc/apt/sources.list.d/intrepid-kernel.list && sudo apt-get update

When I rebooted my pc and plugged in my tv stick, dmesg showed me it was 
detected as Kworld VS-DVB-T 323UR - the
USB-ID is eb1a:e323.
Well, this isn't my card, but it's the same USB-ID. When I started up 
tvtime, video was scrambled, but the audio device is listed in arecord -l.
So I tried modprobe em28xx card=50, which is my MSI DigiVox A/D II - the 
video was alright, but when I ran arecord -D hw:1,0 -f dat | aplay -f 
dat , I only got buffer underruns.
So I pulled a fresh copy from hg, compiled & installed it, rebooted, 
plugged - now the stick gets detected without the card=50 option, but 
still only buffer underruns in arecord | aplay.

what now?

greetings, Bastian


Devin Heitmueller wrote:
> On Tue, Jan 13, 2009 at 6:09 PM, Bastian Beekes <bastian.beekes@gmx.de> wrote:
>> Hm, ok...
>>
>> thanks for your reply in *no time* :)
>> So is the only option to upgrade to 8.10? I'd prefer to stick with the LTS
>> release...
>>
>> Bastian
> 
> I suspect there is some hackary you could do if you install the kernel
> source and recompile to include properly include CONFIG_SND, but
> nobody ever went through the effort (as far as I know).  I believe
> Markus did in his codebase, which is why he has been distributing
> binaries for Ubuntu instead of having people build from source (but I
> could be wrong there).
> 
> The core of the issue is Ubuntu provided an updated ALSA separate from
> the rest of the kernel distro, but then screwed up the kernel headers
> so that we think ALSA isn't present, so v4l-dvb doesn't compile any of
> the alsa modules.
> 
> Devin
> 
