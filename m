Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40139 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2DQL26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 07:28:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2M007XPFVKOLA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 12:28:32 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M009KAFW7OB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 12:28:56 +0100 (BST)
Date: Tue, 17 Apr 2012 13:28:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 01/15] V4L: Extend V4L2_CID_COLORFX with more image effects
In-reply-to: <3eb7475de1e1ce7d7a1dcae7dd11d13c@chewa.net>
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F8D53F7.1050603@samsung.com>
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
 <1334657396-5737-2-git-send-email-s.nawrocki@samsung.com>
 <3eb7475de1e1ce7d7a1dcae7dd11d13c@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2012 12:51 PM, Rémi Denis-Courmont wrote:
> On Tue, 17 Apr 2012 12:09:42 +0200, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> This patch adds definition of additional color effects:
>>  - V4L2_COLORFX_AQUA,
>>  - V4L2_COLORFX_ART_FREEZE,
>>  - V4L2_COLORFX_SILHOUETTE,
>>  - V4L2_COLORFX_SOLARIZATION,
>>  - V4L2_COLORFX_ANTIQUE,
> 
> There starts to be a lot of different color effects with no obvious way to
> determine which ones the current device actually suppots. Should this not
> be a menu control instead?

Fortunately this has been a menu control, since it was introduced. Only 
the DocBook erroneously defined it as an enum. This patch also fixes that, 
please see the DocBook part.

>>  - V4L2_COLORFX_ARBITRARY.
>>
>> The control's type in the documentation is changed from 'enum' to 'menu'
>> - V4L2_CID_COLORFX has always been a menu, not an integer type control.
>>
>> The V4L2_COLORFX_ARBITRARY option enables custom color effects, which
> are
>> impossible or impractical to define as the menu items. For example, the
>> devices may provide coefficients for Cb and Cr manipulation, which yield
>> many permutations, e.g. many slightly different color tints. Such
> devices
>> are better exporting their own API for precise control of non-standard
>> color effects.
> 
> I don't understand why you need a number for this, if it's going to use
> another control anyway... ?

In my use case, the hardware has 3 registers: one of them selects the colour
effect and two others determine Cr, Cb coefficients (probably I could use
V4L2_CID_RED_BALANCE, V4L2_CID_BLUE_BALANCE for that, but so far these are 
just private controls). 

If I would have removed the V4L2_COLORFX_ARBITRARY item, another control
would have to be added (let's say boolean V4L2_PRIV_IMG_EFFECT). Just to 
enable the "arbitrary" effect. 

Then, to enable the arbitrary effect V4L2_CID_COLORFX would have to be set
to V4L2_COLORFX_NONE, nnd V4L2_PRIV_IMG_EFFECT to true.

The CB, CR coefficients are meaningful only when the arbitrary effect is
selected. So having another option in the menu, which drivers can just mask
if they don't support it, appeared better to me. 

It's a bit similar to gain/autogain scenario, where gain is active only when
autogain is off.
Maybe I should just add another private control (V4L2_PRIV_IMG_EFFECT) and
remove V4L2_COLORFX_ARBITRARY item.


---
Thanks,
Sylwester
