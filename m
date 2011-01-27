Return-path: <mchehab@pedra>
Received: from lin106.loading.es ([85.238.11.46]:51057 "EHLO lin106.loading.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab1A0SB1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 13:01:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Jan 2011 18:36:13 +0100
From: Jordi Verdugo <jordiver@staredsi.net>
To: Richard Riley <rileyrg@googlemail.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Avermedia Volar Green HD =?UTF-8?Q?idVendor=3D=30=37ca=2C=20i?=
 =?UTF-8?Q?dProduct=3Da=38=33=35?=
In-Reply-To: <shbp325q76.fsf@news.eternal-september.org>
References: <shbp325q76.fsf@news.eternal-september.org>
Message-ID: <f335dffe30050d5c717c7a3592bcb786@staredsi.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



 For Ubuntu there are a little guide in a Italian forum [1] and i wrote 
 the same
 guide in spanish on my blog[2]. It works but is quite inestable, HD 
 channels
 not works...

 [1]http://forum.ubuntu-it.org/index.php/topic,384436.msg3370690.html#msg3370690
 [2]http://staredsi.wordpress.com/2011/01/12/avertv-volar-hd-pro-a835-en-gnulinux/

 On Thu, 27 Jan 2011 16:19:57 +0100, Richard Riley wrote:

> Hi folks,
>
> My first post to the list : I have done a fair bit of googling around
> but thought I would ask here. Here in germany a popular dvb usb stick 
> is
> the Avermedia Volar Green HD - the major Electronics chain Saturn are
> shifting these quite cheaply.
>
> Here is the output of dmesg when I plug it in
>
> [ 3070.995100] usb 1-1: new high speed USB device using ehci_hcd and
> address 4
> [ 3071.114806] usb 1-1: New USB device found, idVendor=07ca,
> idProduct=a835
> [ 3071.114822] usb 1-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [ 3071.114833] usb 1-1: Product: A835
> [ 3071.114840] usb 1-1: Manufacturer: AVerMedia TECHNOLOGIES, Inc
> [ 3071.114849] usb 1-1: SerialNumber: 3031271017470
>
> Is this/will this be supported?
>
> It is discussed here 
> https://bbs.archlinux.org/viewtopic.php?id=111487
> [1] ,
> but neither patch compiles on my debian squeeze system.
>
> As an aside, I tried to build the sources as described at the LinuxTV 
> web
> page but it
> fails with:-
>
> ,----
> | CC [M] /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.o
> | /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.c: In
> function 'debugifc_parse_unsigned_number':
> | /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.c:108:
> error: implicit declaration of function 'hex_to_bin'
> | make[5]: ***
> [/home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.o] Error 
> 1
> | make[4]: *** [_module_/home/shamrock/builds/src/media_build/v4l] 
> Error
> 2
> | make[3]: *** [sub-make] Error 2
> | make[2]: *** [all] Error 2
> | make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
> | make[1]: *** [default] Fehler 2
> | make[1]: Leaving directory 
> `/home/shamrock/builds/src/media_build/v4l'
> `----
>
> Thanks for any info
>
> regards
>
> r.
>
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-media" in
> the body of a message to majordomo@vger.kernel.org [2]
> More majordomo info at http://vger.kernel.org/majordomo-info.html [3]

-- 

 Jordi Verdugo

 Links:
 ------
 [1] https://bbs.archlinux.org/viewtopic.php?id=111487
 [2] mailto:majordomo@vger.kernel.org
 [3] http://vger.kernel.org/majordomo-info.html
