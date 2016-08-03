Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34848 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbcHCTVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 15:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <20160802113407.25918-1-baolex.ni@intel.com>
References: <20160802113407.25918-1-baolex.ni@intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 3 Aug 2016 21:21:15 +0200
Message-ID: <CAPybu_3B7r-xy5uVLkfhkuH0Pan-R=uq=ONouy=nGzjB2ixCbw@mail.gmail.com>
Subject: Re: [PATCH 0658/1285] Replace numeric parameter like 0444 with macro
To: Baole Ni <baolex.ni@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, maurochehab@gmail.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?Q?Ezequiel_Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
	Hans de Goede <hdegoede@redhat.com>, kgene@kernel.org,
	k.kozlowski@samsung.com, linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>, chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Tue, Aug 2, 2016 at 1:34 PM, Baole Ni <baolex.ni@intel.com> wrote:
> thus, I suggest replacing the numeric parameter with the macro.

For what my opinion is worth it... I found more comprehensive the
octal values than the macros, but maybe it is because I am old and
dream in hexadecimal....

I do not know if there is a consensus about this, but if there is not
maybe we should have that discussion before sending a 1K patchset.

Regards
