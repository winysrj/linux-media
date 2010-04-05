Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:60096 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0DEKC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Apr 2010 06:02:57 -0400
Message-ID: <B4223F04BF7147EA9A1F5CAE8966F318@pcvirus>
From: "rath" <mailings@hardware-datenbank.de>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: <linux-media@vger.kernel.org>
References: <2A74AB3078F34BB484457496310C528B@pcvirus> <4BB9A2E1.5020903@redhat.com>
Subject: Re: update gspca driver in linux source tree
Date: Mon, 5 Apr 2010 12:02:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem with all the trees (http://linuxtv.org/hg/v4l-dvb/ and 
http://linuxtv.org/hg/v4l-dvb/) are the used perl scripts to build the 
makefile. They use "uname -r" to get the kernel version and they use 
directories like "/lib/modules" as default.
Now, I try to cross compile the tree on my ubuntu machine for an ARM 
embedded system. The arm kernel tree is under a different path than 
"/lib/modules/xxxx/build" and "uname -r" returns the kernel version of my 
local machine. So the drivers don't get properly compiled.

After some changes in the perl scripts I was able to cross compile the 
drivers for my ARM linux system. I have already tried it some weeks before, 
but at that time I had no succes. For this reason I tried it by copying the 
driver sources into my ARM kernel tree. Now it works for me.

I have still one question: Where can I find the ".config" file in the linux 
tree after "make menuconfig"?

Regards, Joern


> You will want to not use my tree, but use the latest generic tree:
> hg clone http://linuxtv.org/hg/v4l-dvb/
> Then simply compile that tree (this will need the headers of your 2.6.29 
> kernel
> in the usual place):
> cd v4l-dvb
> make menuconfig
> make
> sudo make install
>
> And then reboot, now you will be using your 2.9.29 kernel with a fully
> up2date v4l-dvb subsystem.
>
> Regards,
>
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

