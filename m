Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:40439 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZHBKOO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2009 06:14:14 -0400
Date: Sun, 2 Aug 2009 12:14:01 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] gspca - vc032x: H and V flip
 controls added for mi13x0_soc sensors.
Message-ID: <20090802121401.665c4613@tele>
In-Reply-To: <200908021133.25624.hverkuil@xs4all.nl>
References: <E1MWegK-00046z-Si@mail.linuxtv.org>
	<200908021133.25624.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2 Aug 2009 11:33:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> he daily build produces this warning:
> 
> /marune/build/v4l-dvb-master/v4l/vc032x.c: In function 'sethvflip':
> /marune/build/v4l-dvb-master/v4l/vc032x.c:3138: warning: statement
> with no effect /marune/build/v4l-dvb-master/v4l/vc032x.c:3141:
> warning: statement with no effect
> 
> And looking at the code those warnings are correct. I think you
> wanted to do 'hflip = !hflip'.
> 
> Can you take a look at this?

Hi Hans,

Sorry, I did not see that. It is fixed.

Many thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
