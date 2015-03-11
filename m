Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:33991 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbCKQgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 12:36:24 -0400
Received: by qcvp6 with SMTP id p6so11658496qcv.1
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 09:36:23 -0700 (PDT)
Message-ID: <55006E71.9020403@vanguardiasur.com.ar>
Date: Wed, 11 Mar 2015 13:33:53 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>,
	Dale Hamel <dale.hamel@srvthe.net>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	"mchehab@osg.samsung.com" <mchehab@osg.samsung.com>,
	"michael@stegemann.it" <michael@stegemann.it>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add framescaling support to stk1160
References: <1424799211-26488-1-git-send-email-dale.hamel@srvthe.net> <CALF0-+U1LiWLh8H0TszoamPk7KZwM2zO4guavB0MQTXybnoBwA@mail.gmail.com>
In-Reply-To: <CALF0-+U1LiWLh8H0TszoamPk7KZwM2zO4guavB0MQTXybnoBwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael, Dale,

On 03/10/2015 12:26 AM, Ezequiel Garcia wrote:
> Dale,
> 
> Don't forget to Cc the media mailing list. See below.
> 

If you are OK with it, I'll rework this patch (mostly cleaning the
style) and then post it back so everyone can comment.

BTW, my datasheet doesn't have the DMCTRL register documented, and I'm
really glad that we can finally support hardware decimation.

Thanks!
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
