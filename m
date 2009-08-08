Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1513 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933729AbZHHJcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 05:32:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv14 4/8] v4l2-spec: Add documentation description for FM TX extended control class
Date: Sat, 8 Aug 2009 11:32:24 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248707530-4068-1-git-send-email-eduardo.valentin@nokia.com> <1248707530-4068-4-git-send-email-eduardo.valentin@nokia.com> <1248707530-4068-5-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1248707530-4068-5-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081132.24460.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 27 July 2009 17:12:06 Eduardo Valentin wrote:
> This single patch adds documentation description for FM Modulator (FM TX)
> Extended Control Class and its Control IDs. The text was added under
> "Extended Controls" section.

I just came across a missing bit of spec: in vidioc-g-ext-ctrls.sgml there
is a table with control classes. The new FM_TX control class should be added
there as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
