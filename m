Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:52031 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZBMKLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 05:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <49954532.2070502@maxwell.research.nokia.com>
References: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
	 <5e9665e10902102000i3433beb8jab7a70e7ac9b57e3@mail.gmail.com>
	 <4993CB1F.603@maxwell.research.nokia.com>
	 <5e9665e10902112352i57177f20r9022a7cb8a66fa0@mail.gmail.com>
	 <49954532.2070502@maxwell.research.nokia.com>
Date: Fri, 13 Feb 2009 19:11:13 +0900
Message-ID: <5e9665e10902130211h3aafb095l6bb3b50bc2cbf2fe@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi! Sakari.

On Fri, Feb 13, 2009 at 7:02 PM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> DongSoo Kim wrote:
>>
>> Thank you for your comment.
>>
>> BTW, what should I do if I would rather use external ISP device than
>> OMAP3 internal ISP feature?
>>
>> You said that you just have raw sensors by now, so you mean this patch
>> is not verified working with some ISP modules?
>
> I haven't verified it myself. Others might be using it.

Some people using external ISP have informed me.
Thank you.

>
>> I'm testing your patch on my own omap3 target board with NEC ISP...but
>> unfortunately not working yet ;(
>
> NEC ISP? A sensor with NEC ISP integrated?

Yep. CE131 exactly.

>
>> I should try more harder. more research is needed :)
>
> Thanks for the interest. :-)

Thank you too :)
I wish I could send you my work as a patch ASAP.

Cheers,

Nate

>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>



-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
