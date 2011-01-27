Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52290 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1A0VmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 16:42:09 -0500
Received: by ywe10 with SMTP id 10so796931ywe.19
        for <linux-media@vger.kernel.org>; Thu, 27 Jan 2011 13:42:08 -0800 (PST)
From: Richard Riley <rileyrg@googlemail.com>
To: Jordi Verdugo <jordiver@staredsi.net>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Avermedia Volar Green HD idVendor=07ca, idProduct=a835
In-Reply-To: <f335dffe30050d5c717c7a3592bcb786@staredsi.net> (Jordi Verdugo's
	message of "Thu, 27 Jan 2011 18:36:13 +0100")
Date: Thu, 27 Jan 2011 19:48:52 +0100
Message-ID: <uumxmmrxm3.fsf@news.eternal-september.org>
References: <shbp325q76.fsf@news.eternal-september.org>
	<f335dffe30050d5c717c7a3592bcb786@staredsi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Jordi Verdugo <jordiver@staredsi.net> writes:

> For Ubuntu there are a little guide in a Italian forum [1] and i wrote the same
> guide in spanish on my blog[2]. It works but is quite inestable, HD channels
> not works...
>
> [1]http://forum.ubuntu-it.org/index.php/topic,384436.msg3370690.html#msg3370690
> [2]http://staredsi.wordpress.com/2011/01/12/avertv-volar-hd-pro-a835-en-gnulinux/

Yeah, it doesnt compile for me. Am I better off just getting a different
card? I felt sure the avermedia would be supported ;) Mea culpa!

,----
| Kernel build directory is /lib/modules/2.6.32-5-686/build
| make -C /lib/modules/2.6.32-5-686/build SUBDIRS=/home/shamrock/builds/src/tda18218/v4l  modules
| make[2]: Entering directory `/usr/src/linux-headers-2.6.32-5-686'
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tuner-xc2028.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tuner-simple.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tuner-types.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/mt20xx.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tda8290.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tea5767.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tea5761.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tda9887.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/tda827x.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/au0828-core.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/au0828-i2c.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/au0828-cards.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/au0828-dvb.o
|   CC [M]  /home/shamrock/builds/src/tda18218/v4l/au0828-video.o
| /home/shamrock/builds/src/tda18218/v4l/au0828-video.c: In function 'au0828_uninit_isoc':
| /home/shamrock/builds/src/tda18218/v4l/au0828-video.c:184: error: implicit declaration of function 'usb_free_coherent'
| /home/shamrock/builds/src/tda18218/v4l/au0828-video.c: In function 'au0828_init_isoc':
| /home/shamrock/builds/src/tda18218/v4l/au0828-video.c:254: error: implicit declaration of function 'usb_alloc_coherent'
| /home/shamrock/builds/src/tda18218/v4l/au0828-video.c:255: warning: assignment makes pointer from integer without a cast
| make[5]: *** [/home/shamrock/builds/src/tda18218/v4l/au0828-video.o] Error 1
| make[4]: *** [_module_/home/shamrock/builds/src/tda18218/v4l] Error 2
| make[3]: *** [sub-make] Error 2
| make[2]: *** [all] Error 2
| make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
| make[1]: *** [default] Fehler 2
| make[1]: Leaving directory `/home/shamrock/builds/src/tda18218/v4l'
`----


>
> On Thu, 27 Jan 2011 16:19:57 +0100, Richard Riley wrote:
>
>> Hi folks,
>>
>> My first post to the list : I have done a fair bit of googling around
>> but thought I would ask here. Here in germany a popular dvb usb stick is
>> the Avermedia Volar Green HD - the major Electronics chain Saturn are
>> shifting these quite cheaply.
>>
>> Here is the output of dmesg when I plug it in
>>
>> [ 3070.995100] usb 1-1: new high speed USB device using ehci_hcd and
>> address 4
>> [ 3071.114806] usb 1-1: New USB device found, idVendor=07ca,
>> idProduct=a835
>> [ 3071.114822] usb 1-1: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [ 3071.114833] usb 1-1: Product: A835
>> [ 3071.114840] usb 1-1: Manufacturer: AVerMedia TECHNOLOGIES, Inc
>> [ 3071.114849] usb 1-1: SerialNumber: 3031271017470
>>
>> Is this/will this be supported?
>>
>> It is discussed here https://bbs.archlinux.org/viewtopic.php?id=111487
>> [1] ,
>> but neither patch compiles on my debian squeeze system.
>>
>> As an aside, I tried to build the sources as described at the LinuxTV web
>> page but it
>> fails with:-
>>
>> ,----
>> | CC [M] /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.o
>> | /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.c: In
>> function 'debugifc_parse_unsigned_number':
>> | /home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.c:108:
>> error: implicit declaration of function 'hex_to_bin'
>> | make[5]: ***
>> [/home/shamrock/builds/src/media_build/v4l/pvrusb2-debugifc.o] Error 1
>> | make[4]: *** [_module_/home/shamrock/builds/src/media_build/v4l] Error
>> 2
>> | make[3]: *** [sub-make] Error 2
>> | make[2]: *** [all] Error 2
>> | make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
>> | make[1]: *** [default] Fehler 2
>> | make[1]: Leaving directory `/home/shamrock/builds/src/media_build/v4l'
>> `----
>>
>> Thanks for any info
>>
>> regards
>>
>> r.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org [2]
>> More majordomo info at http://vger.kernel.org/majordomo-info.html [3]

-- 
☘ http://www.shamrockirishbar.com, http://splash-of-open-sauce.blogspot.com/ http://www.richardriley.net
