Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1396 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069Ab3HHLx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 07:53:58 -0400
Message-ID: <520386CD.3070102@xs4all.nl>
Date: Thu, 08 Aug 2013 13:53:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?B=E5rd_Eirik_Winther?= <bwinther@cisco.com>
CC: linux-media@vger.kernel.org, hansverk@cisco.com
Subject: Re: [git:v4l-utils/master] qv4l2: add aspect ratio support
References: <E1V7L76-0005aC-HM@www.linuxtv.org> <2733966.NUgGszmazj@bwinther>
In-Reply-To: <2733966.NUgGszmazj@bwinther>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2013 01:32 PM, Bård Eirik Winther wrote:
> Hi.
> 
> Bad news. While rebasing my cropping support branch I noticed that Hans has merged in the wrong patch series for the scaling.

My bad, sorry. I've reverted the changes.

> The one Hans have merged is one of our internal revisions, as only v1 is present on the mailing list.
> I sent out a full patch series on Tuesday that consists of 9 parts, wheras the part you have merged is only 7 (from YUY2 shader to aspect ratio).

The reason I got confused was that the newer patch series no longer applies. Can
you rebase it and post again?

Thanks!

	Hans

> 
> B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

