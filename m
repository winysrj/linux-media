Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34625 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbcBVNb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 08:31:58 -0500
MIME-Version: 1.0
In-Reply-To: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
References: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Date: Mon, 22 Feb 2016 14:31:29 +0100
Message-ID: <CAO3366xjUHVYmFJhovZp=WqsWyZAjEsOps1exSqhemdtqu-=Nw@mail.gmail.com>
Subject: Re: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
From: Ulrich Hecht <ulrich.hecht@gmail.com>
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 14, 2016 at 5:55 PM, Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Also I
> could only get frames if the video signal on the composite IN was NTSC,
> but this also applied to the soc_camera driver, it might be my test
> setup.

I think it is.  For me, PAL works just as well as NTSC.

CU
Uli
