Return-path: <mchehab@localhost.localdomain>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:39499 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab0IMLqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 07:46:31 -0400
Subject: Re: [PATCH v9 0/4] FM Radio driver.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <201009131332.15287.hverkuil@xs4all.nl>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <201009111410.55149.hverkuil@xs4all.nl>
	 <1284375031.12913.35.camel@masi.mnp.nokia.com>
	 <201009131332.15287.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 14:44:31 +0300
Message-ID: <1284378271.12913.42.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Mon, 2010-09-13 at 13:32 +0200, ext Hans Verkuil wrote:
> > Anyway the difference between the "completely raw bits" and the "raw"
> > blocks is small. And I doubt the usefulness of supporting the
> > "completely raw" format.
> 
> I don't intend to support it now. But we need to realize that it exists and
> we have to plan for it.

OK. So we can have RDS_RAW_READWRITE and also RDS_RAW_BLOCK_READWRITE
(or something to the same effect)?

B.R.
Matti


