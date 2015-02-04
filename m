Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:44134 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986AbbBDQxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 11:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5D5QQQj6u7av4TTAY7gbRXXx7AF_eYJiQxuPtgo9zsQtQ@mail.gmail.com>
References: <1421365163-29394-1-git-send-email-prabhakar.csengg@gmail.com>
 <CAL_Jsq+Yk1sDT+KfxRfR3ue74KtKxDB3Aj0BS2=sfYwzMcQtDw@mail.gmail.com> <CAOMZO5D5QQQj6u7av4TTAY7gbRXXx7AF_eYJiQxuPtgo9zsQtQ@mail.gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 4 Feb 2015 10:52:53 -0600
Message-ID: <CAL_JsqJ9oxgKsCSeNaPFANFq_rzCGYNg+oZEfgy2gmY7SYGt2A@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: add support for omnivision's ov2659 sensor
To: Fabio Estevam <festevam@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Grant Likely <grant.likely@linaro.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 4, 2015 at 9:23 AM, Fabio Estevam <festevam@gmail.com> wrote:
> Rob,
>
> On Wed, Feb 4, 2015 at 12:55 PM, Rob Herring <robherring2@gmail.com> wrote:
>
>> I'm surprised there are not already compatible strings with
>> OmniVision. There are some examples using "omnivision", but no dts
>> files and examples don't count.
>>
>> The stock ticker is ovti, so please use that.
>
> That's what I sent:
> http://patchwork.ozlabs.org/patch/416685/
>
> Could you apply it?

Yes. Now applied.

Rob
