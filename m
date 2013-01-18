Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56055 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3ARJTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 04:19:38 -0500
Received: by mail-ea0-f177.google.com with SMTP id n13so1340578eaa.36
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2013 01:19:37 -0800 (PST)
Message-ID: <50F911DB.50102@gmail.com>
Date: Fri, 18 Jan 2013 10:11:55 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: af9035 test needed!
References: <50F05C09.3010104@iki.fi>
In-Reply-To: <50F05C09.3010104@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 11/01/2013 19:38, Antti Palosaari ha scritto:
> Hello Jose and Gianluca
> 
> Could you test that (tda18218 & mxl5007t):
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_tuner
> 
> 
> I wonder if ADC config logic still works for superheterodyne tuners
> (tuner having IF). I changed it to adc / 2 always due to IT9135 tuner.
> That makes me wonder it possible breaks tuners having IF, as ADC was
> clocked just over 20MHz and if it is half then it is 10MHz. For BB that
> is enough, but I think that having IF, which is 4MHz at least for 8MHz
> BW it is too less.

Hi Antti,
I tested your latest tree and both the Avermedia A835 (af9035+tda18218)
and the A867 (af9035+mxl5007t) work perfectly fine. I could not find any
change in the behavior of the two devices.

BTW, there are reports on several Italian forums (like this:
http://www.vuplus-community.net/board/threads/varie-prove-fatte-su-vu-uno-e-digital-key-a867-led-blu.9930/)
that a new revision of the A867 stick (marked as "A867-DP7") does not
work with the current af9035 driver, but it works perfectly fine when
Jose's patch for the mxl5007t tuner is applied. I have an older "DP5"
revision that always worked fine with the af9035 driver, so I cannot
test the new "DP7" revision directly.

> 
> F*ck I hate to maintain driver without a hardware! Any idea where I can
> get AF9035 device having tda18218 or mxl5007t?

Here are a couple of links to buy cheap af9035 sticks.

Avermedia A835/B835: af9035 + tda18218, also known ad "Avermedia Volar
HD" or "Avermedia Volar HD Pro" or "Avermedia Volar Green HD".
The only difference between the models seems to be the presence of the
remote controller and the IR sensor:

http://www.amazon.it/Avermedia-Avertv-Volar-Green-Hd/dp/B003GXAMEM/ref=sr_1_2?ie=UTF8&qid=1358499827&sr=8-2

http://www.amazon.it/Avermedia-Avertv-Volar-Hd-Pro/dp/B003ACL1ZI/ref=sr_1_1?ie=UTF8&qid=1358499827&sr=8-1

Avermedia A867: af9035 + mxl5007t, also known as "Aver Media AVerTV 3D"
or "Sky Digital Key with blue led". You can buy them very cheap on Ebay
Italia because Sky Italia is giving away them almost for free to its
subscribers, to add DVB-T support to the Skyboxes. You can find dozens
of items looking for "Sky Digital Key Blu Led" on the Italian Ebay:

http://www.ebay.it/sch/i.html?_trksid=p3902.m570.l1313&_nkw=sky+digital+key+blu&_sacat=0&_from=R40

or you can buy the retail model:

http://www.amazon.it/Avermedia-AverTV-Volar-Entertainment-Pack/dp/B003TPW5WO/ref=sr_1_2?s=electronics&ie=UTF8&qid=1358499900&sr=1-2

As an alternative, I could ask a friend if he is willing to lend you the
2 sticks for all the time you need. He has both the A835 and the A867
"DP7" revision. Let me know if you are interested.

Regards,
Gianluca

> 
> regards
> Antti
> 

