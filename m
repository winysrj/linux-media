Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:47789 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZL3MNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 07:13:15 -0500
Date: Wed, 30 Dec 2009 13:14:05 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>, cocci@diku.dk
Subject: Re: [PATCH] gspca: make control descriptors constant
Message-ID: <20091230131405.1ad16ba1@tele>
In-Reply-To: <4B3A7890.7060109@freemail.hu>
References: <4B3A7890.7060109@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 29 Dec 2009 22:45:52 +0100
Németh Márton <nm127@freemail.hu> wrote:

> The ctrls field of struct sd_desc is declared as const
> in gspca.h. It is worth to initialize the content also with
> constant values.

Thanks, I got it.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
