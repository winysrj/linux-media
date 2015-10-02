Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35198 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbJBJGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 05:06:21 -0400
Received: by obbzf10 with SMTP id zf10so77553385obb.2
        for <linux-media@vger.kernel.org>; Fri, 02 Oct 2015 02:06:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1443775046.3445.49.camel@pengutronix.de>
References: <1437063883-23981-1-git-send-email-p.zabel@pengutronix.de>
 <1437063883-23981-6-git-send-email-p.zabel@pengutronix.de>
 <55B255CD.3050304@xs4all.nl> <CAH-u=81qpYNgMvkKocc6weDqoWB3tW0r5csmVZfxSYfQ-74wsQ@mail.gmail.com>
 <1443775046.3445.49.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Fri, 2 Oct 2015 11:06:01 +0200
Message-ID: <CAH-u=82YoBzV4KWGP+eSdzOEnk8UuRreL_sH6NU+smNnjDanuw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] [media] imx-ipu: Add i.MX IPUv3 scaler driver
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, David Airlie <airlied@linux.ie>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Michael Olbrich <m.olbrich@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-10-02 10:37 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Jean-Michel,
>
> Am Donnerstag, den 01.10.2015, 09:55 +0200 schrieb Jean-Michel Hautbois:
>> Hi Philipp, Hans,
>>
>>
>> 2015-07-24 17:12 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> [...]
>> What is the status of this driver ?
>> I can test it here, Philipp, are you planning to take Hans remarks
>> into account in one of your trees ?
>
> Thank you for the reminder!
>
> I have fixed most of the issues Hans pointed out, but got distracted at
> some point and left for other things. I'll prepare a new version of this
> series.

OK, don't hesitate if you need some tests ;-).
BTW, I am modifying coda support V4L2_ENC_CMD_STOP.
I will propose a patch during the day, it is probably not perfect, so
your review will be appreciated :).

JM
PS: Will you be there at ELCE next week ?
