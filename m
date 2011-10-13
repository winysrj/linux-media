Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46589 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1JMNVo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 09:21:44 -0400
Message-ID: <4E96E5E5.2060702@iki.fi>
Date: Thu, 13 Oct 2011 16:21:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ling Sequera <lingstein@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: support for tv tuner tda18211 in Iconbit U100 analog stick
References: <CAMxCp9cSmoLipFpgAYMML0YQaGvxj36rw3xm_Zku4uaCzKZQ8A@mail.gmail.com>
In-Reply-To: <CAMxCp9cSmoLipFpgAYMML0YQaGvxj36rw3xm_Zku4uaCzKZQ8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CX23102 + TDA18211 (== DVB-T only version of TDA18271)

Maybe someone have better knowledge about that as I am not any familiar 
with CX23102 nor analog TV side.

Antti

On 10/09/2011 03:56 AM, Ling Sequera wrote:
> I try to post this at linux-media@vger.kernel.org
> <mailto:linux-media@vger.kernel.org>, but the system rejects the
> sending, Excuse me for send this to you, I have understood that you are
> one of the developers of the tda18271 module.
>
> I have a "Mygica u719c usb analog tv stick", lsusb output identify this
> device as: "ID 1f4d:0237 G-Tek Electronics Group". Googling, I found
> that this device is the same "Iconbit Analog Stick U100 FM
> <http://translate.google.es/translate?sl=ru&tl=en&js=n&prev=_t&hl=es&ie=UTF-8&layout=2&eotf=1&u=http%3A%2F%2Fwww.f1cd.ru%2Ftuners%2Freviews%2Ficonbit_u100_fm_iconbit_u500_fm_page_1%2F>",
> which has support in the kernel since version 3.0 as shown here
> <http://cateee.net/lkddb/web-lkddb/VIDEO_CX231XX.html>. I opened the
> device to corfirm this information, and effectively, it has to chips,
> the demod Conexan "CX23102" and the DVB-T tuner NPX "TDA-18211". I
> installed the precompiled version of kernel 3.0.4, and the device was
> reconized, but only works in the modes: composite and s-video. I check
> the source code and I found that it don't support tv tuner mode
> (.tuner_type=TUNER_ABSENT in 513 line of the cx231xx-cards.c
> <http://lxr.linux.no/#linux+v3.0.4/drivers/media/video/cx231xx/cx231xx-cards.c>
> source file), I want to add support for this. The TDA-18211 tuner has
> support in the kernel in the module tda18271 according to the thread of
> this mailing list
> <http://www.mail-archive.com/linux-dvb@linuxtv.org/msg30055.html>. I
> have never written a module, but I have basic knowledge in C, so I need
> a book, reference, api, or something, to write the missing code to add
> support for this device as tv tuner. Also I need help understanding how
> to read usb-snoop log files and identify the necessary parameters for
> configure the code. Thanks in advance.
>
> Best regards.


-- 
http://palosaari.fi/
