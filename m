Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2249 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0IMLvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 07:51:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Subject: Re: [PATCH v9 0/4] FM Radio driver.
Date: Mon, 13 Sep 2010 13:51:35 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com> <201009131332.15287.hverkuil@xs4all.nl> <1284378271.12913.42.camel@masi.mnp.nokia.com>
In-Reply-To: <1284378271.12913.42.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131351.35487.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, September 13, 2010 13:44:31 Matti J. Aaltonen wrote:
> On Mon, 2010-09-13 at 13:32 +0200, ext Hans Verkuil wrote:
> > > Anyway the difference between the "completely raw bits" and the "raw"
> > > blocks is small. And I doubt the usefulness of supporting the
> > > "completely raw" format.
> > 
> > I don't intend to support it now. But we need to realize that it exists and
> > we have to plan for it.
> 
> OK. So we can have RDS_RAW_READWRITE and also RDS_RAW_BLOCK_READWRITE
> (or something to the same effect)?

In theory, yes. My proposed API additions allow for this to be added in the
future. Frankly, I don't think it is likely that it will be needed, but you
never know.

Regards,

	Hans

> 
> B.R.
> Matti
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
