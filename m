Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38421 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932365AbcGDJoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 05:44:18 -0400
Subject: Re: [PATCH RFC v2 0/2] pxa_camera transition to v4l2 standalone
 device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b615c0da-616e-7c26-c345-c89e8ac8844e@xs4all.nl>
Date: Mon, 4 Jul 2016 11:44:13 +0200
MIME-Version: 1.0
In-Reply-To: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/02/2016 04:26 PM, Robert Jarzmik wrote:
> Hi Hans and Guennadi,
> 
> This is the second opus of this RFC. The goal is still to see how close our
> ports are to see if there are things we could either reuse of change.
> 
> From RFCv1, the main change is cleaning up in function names and functions
> grouping, and fixes to make v4l2-compliance happy while live tests still show no
> regression.
> 
> For the next steps, I'll have to :
>  - split the second patch, which will be a headache task, into :
>    - first functions grouping and renaming
>      => this to ensure the "internal functions" are almost untouched

It helps to review, but don't spend too much time on this either. By and large
it didn't look too bad when I reviewed the code.

Regards,

	Hans
