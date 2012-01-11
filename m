Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:57181 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932465Ab2AKOqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 09:46:47 -0500
Received: by bkwq16 with SMTP id q16so665485bkw.31
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 06:46:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPc4S2YnZBTY4F5q1152mUA7eipgLm6XQPH9PAv8x5O6rzvf4A@mail.gmail.com>
References: <CAPc4S2YPRWHhTJY0C5gMYtFgULHibfaqGuPOeU-fFxm9XfxYjg@mail.gmail.com>
	<CAPc4S2YnZBTY4F5q1152mUA7eipgLm6XQPH9PAv8x5O6rzvf4A@mail.gmail.com>
Date: Wed, 11 Jan 2012 08:46:44 -0600
Message-ID: <CAPc4S2Zh19n7xndyqG_BuwUaVFVCxRiYcHj=-sBSSmyhmKRs6Q@mail.gmail.com>
Subject: Re: No video on generic SAA7134 card
From: Christopher Peters <cpeters@ucmo.edu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was able to get video out of the card using the option:

options saa7134 card=33,33,33,33

KP
-- 
-
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
