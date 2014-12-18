Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58211 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaLRMV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 07:21:29 -0500
MIME-Version: 1.0
In-Reply-To: <5492C4E3.4050401@samsung.com>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com>
	<1418869646-17071-6-git-send-email-josh.wu@atmel.com>
	<5492C4E3.4050401@samsung.com>
Date: Thu, 18 Dec 2014 10:21:27 -0200
Message-ID: <CAOMZO5B7tFUMjUA-y25Q3u_6jroEN8WxXj431=2XuiOLQ1dEuA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] media: ov2640: dt: add the device tree binding document
From: Fabio Estevam <festevam@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Josh Wu <josh.wu@atmel.com>,
	linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Dec 18, 2014 at 10:13 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Josh,
>
> On 18/12/14 03:27, Josh Wu wrote:
>> Add the document for ov2640 dt.
>>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> It seems "ovti" is not in the list of vendor prefixes. You may want
> to send a patch adding it to Documentation/devicetree/bindings/
> vendor-prefixes.txt.

I have already sent it:
http://patchwork.ozlabs.org/patch/416685/
