Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34175 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2DVQBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 12:01:00 -0400
Received: by bkcik5 with SMTP id ik5so8055590bkc.19
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2012 09:00:59 -0700 (PDT)
Message-ID: <4F942B31.7050500@gmail.com>
Date: Sun, 22 Apr 2012 18:00:49 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?B?UsOpbWkgRGVuaXM=?= =?UTF-8?B?LUNvdXJtb250?=
	<remi@remlab.net>, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 01/15] V4L: Extend V4L2_CID_COLORFX with more image effects
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com> <1334657396-5737-2-git-send-email-s.nawrocki@samsung.com> <3eb7475de1e1ce7d7a1dcae7dd11d13c@chewa.net> <4F8D53F7.1050603@samsung.com>
In-Reply-To: <4F8D53F7.1050603@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2012 01:28 PM, Sylwester Nawrocki wrote:
> On 04/17/2012 12:51 PM, Rémi Denis-Courmont wrote:
>> On Tue, 17 Apr 2012 12:09:42 +0200, Sylwester Nawrocki
>> <s.nawrocki@samsung.com>  wrote:
>>> This patch adds definition of additional color effects:
>>>   - V4L2_COLORFX_AQUA,
>>>   - V4L2_COLORFX_ART_FREEZE,
>>>   - V4L2_COLORFX_SILHOUETTE,
>>>   - V4L2_COLORFX_SOLARIZATION,
>>>   - V4L2_COLORFX_ANTIQUE,
>>
>> There starts to be a lot of different color effects with no obvious way to
>> determine which ones the current device actually suppots. Should this not
>> be a menu control instead?
> 
> Fortunately this has been a menu control, since it was introduced. Only
> the DocBook erroneously defined it as an enum. This patch also fixes that,
> please see the DocBook part.
> 
>>>   - V4L2_COLORFX_ARBITRARY.
>>>
>>> The control's type in the documentation is changed from 'enum' to 'menu'
>>> - V4L2_CID_COLORFX has always been a menu, not an integer type control.
>>>
>>> The V4L2_COLORFX_ARBITRARY option enables custom color effects, which
>> are
>>> impossible or impractical to define as the menu items. For example, the
>>> devices may provide coefficients for Cb and Cr manipulation, which yield
>>> many permutations, e.g. many slightly different color tints. Such
>> devices
>>> are better exporting their own API for precise control of non-standard
>>> color effects.
>>
>> I don't understand why you need a number for this, if it's going to use
>> another control anyway... ?
> 
> In my use case, the hardware has 3 registers: one of them selects the colour
> effect and two others determine Cr, Cb coefficients (probably I could use
> V4L2_CID_RED_BALANCE, V4L2_CID_BLUE_BALANCE for that, but so far these are
> just private controls).
> 
> If I would have removed the V4L2_COLORFX_ARBITRARY item, another control
> would have to be added (let's say boolean V4L2_PRIV_IMG_EFFECT). Just to
> enable the "arbitrary" effect.
> 
> Then, to enable the arbitrary effect V4L2_CID_COLORFX would have to be set
> to V4L2_COLORFX_NONE, and V4L2_PRIV_IMG_EFFECT to true.
> 
> The CB, CR coefficients are meaningful only when the arbitrary effect is
> selected. So having another option in the menu, which drivers can just mask
> if they don't support it, appeared better to me.
> 
> It's a bit similar to gain/autogain scenario, where gain is active only when
> autogain is off.
> Maybe I should just add another private control (V4L2_PRIV_IMG_EFFECT) and
> remove V4L2_COLORFX_ARBITRARY item.

Instead of an imprecise V4L2_COLORFX_ARBITRARY, I'm considering adding 
V4L2_COLORFX_CHROMA_BALANCE item and document that it should be used together 
with V4L2_CID_RED_BALANCE and V4L2_CID_BLUE_BALANCE controls. Would something 
like this be acceptable ? I'd like to avoid (many) private controls if possible.

---
Regards,
Sylwester
