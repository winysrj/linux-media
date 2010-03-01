Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:34516 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab0CAGyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 01:54:44 -0500
Date: Mon, 1 Mar 2010 07:55:03 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Olivier Lorin <olorin75@gmail.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] New driver for MI2020 sensor with GL860 bridge
Message-ID: <20100301075503.5963576f@tele>
In-Reply-To: <1267388365.1854.30.camel@miniol>
References: <1267388365.1854.30.camel@miniol>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Feb 2010 21:19:25 +0100
Olivier Lorin <olorin75@gmail.com> wrote:

> - General changes for all drivers because of new MI2020 sensor
> driver :
>   - add the light source control
>   - control value changes only applied after an end of image
>   - replace msleep with duration less than 5 ms by a busy loop
> - Fix for an irrelevant OV9655 image resolution identifier name

Hello Olivier,

What is this 'light source'? In the list, we are talking about the
webcam LEDs and how to switch them on/off. Is it the same feature?

Is it important to have a so precise delay in the webcam exchanges?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
