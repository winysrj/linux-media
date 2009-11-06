Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:52037 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZKFHg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 02:36:28 -0500
Date: Fri, 6 Nov 2009 08:36:26 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars Noschinski <lars@public.noschinski.de>
Cc: linux-media@vger.kernel.org
Subject: Re: pac7311
Message-ID: <20091106083626.3fbe8428@tele>
In-Reply-To: <20091105233843.GA27459@lars.home.noschinski.de>
References: <20091105233843.GA27459@lars.home.noschinski.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Nov 2009 00:38:43 +0100
Lars Noschinski <lars@public.noschinski.de> wrote:

> I'm using a webcam which identifies itself as
> 
>     093a:2603 Pixart Imaging, Inc. PAC7312 Camera
> 
> and is sort-of supported by the gspca_pac7311 module. "sort-of"
> because the image alternates quickly between having a red tint or a
> green tint (using the gspca driver from
> http://linuxtv.org/hg/~jfrancois/gspca/ on a 2.6.31 kernel; occurs
> also with plain 2.6.31).
> 
> Is there something I can do to debug/fix this problem?

Hello Lars,

First, which viewer do you run and does it use the v4l2 library?

Then, a bug in the pac7311 driver has been found yesterday. Did you
get/try this last one?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
