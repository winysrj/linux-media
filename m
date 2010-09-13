Return-path: <mchehab@localhost.localdomain>
Received: from smtp.nokia.com ([147.243.1.47]:23861 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0IMKvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 06:51:00 -0400
Subject: Re: [PATCH v9 0/4] FM Radio driver.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <201009111410.55149.hverkuil@xs4all.nl>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <201009111410.55149.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 13:50:31 +0300
Message-ID: <1284375031.12913.35.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Sat, 2010-09-11 at 14:10 +0200, ext Hans Verkuil wrote:
> There are also up to three ways the RDS data can be received/sent: either as
> RDS blocks, or using controls, or as a completely raw bitstream. The latter is
> unlikely to be used for RDS output, but a cheap RDS receiver might just do this
> (and I believe these devices actually exist).

I thought that the "raw" mode meant reading and writing (uninterpreted)
RDS blocks. At least that's what the wl1273 chip does and that was what
I meant. Is there already a way to deal with this case?

Anyway the difference between the "completely raw bits" and the "raw"
blocks is small. And I doubt the usefulness of supporting the
"completely raw" format.

B.R.
Matti

> So I propose to add the following tuner capability flags:
> 
> V4L2_TUNER_CAP_RDS_READWRITE	0x0100	Use read()/write()
> V4L2_TUNER_CAP_RDS_CONTROLS	0x0200	Use RDS controls
> 
> And this allows us to add a RDS_RAW_READWRITE in the future should we need it.
> 
> We do need to add these capability flags to the existing RDS drivers (there
> are only a few, so that's no problem) and we need to document that for RDS
> capture the READWRITE is the default if neither READWRITE or CONTROLS is set,
> and that for RDS output the CONTROLS is the default in that case.
> 
> Comments?
> 
> 	Hans
> 


