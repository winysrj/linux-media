Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1106 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZFHJbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 05:31:02 -0400
Message-ID: <53644.62.70.2.252.1244453448.squirrel@webmail.xs4all.nl>
Date: Mon, 8 Jun 2009 11:30:48 +0200 (CEST)
Subject: Re: [PATCHv6 0 of 7] FM Transmitter (si4713) and another changes
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Eduardo Valentin" <eduardo.valentin@nokia.com>
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Linux-Media" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>,
	"Eduardo Valentin" <eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello all,
>
>   I'm resending the FM transmitter driver and the proposed changes in
> v4l2 api files in order to cover the fmtx extended controls class.
>
>   Difference from version #5 is that now I've dropped the patch which
> adds a new i2c helper function. And now this series is based on Hans
> tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev. That tree
> has the proper refactoring of v4l2 i2c helper functions. The work
> done before in the patch dropped here, now was done by Hans.
>
>   So, now the series includes only changes to add the new v4l2
> FMTX extended controls (and its documetation) and si4713 i2c and platform
> drivers (and its documentation as well).

Pending unforeseen circumstances I will do a full review tomorrow.

Regards,

        Hans

>   Again, comments are welcome.
>
> BR,
>
> ---
> Eduardo Valentin
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

