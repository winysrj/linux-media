Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:48380 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbZKGKyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 05:54:12 -0500
Date: Sat, 7 Nov 2009 11:54:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca pac7302: simplify init sequence
Message-ID: <20091107115411.51d213e3@tele>
In-Reply-To: <4AF540BF.8000905@freemail.hu>
References: <4AF540BF.8000905@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 07 Nov 2009 10:41:19 +0100
Németh Márton <nm127@freemail.hu> wrote:

> The init sequence contains register writes which are overwritten
> later. Remove these redundant writes from the init sequence.
	[snip]

Hello Németh,

I am not sure it is a good idea. The webcam may need some
initialization values to start working before the control are applied.
Also, if any problem occurs, it is not easy to find the differences
with the ms-win traces.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
