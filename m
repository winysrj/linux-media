Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38847 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab2IGUPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 16:15:48 -0400
Received: by eaac11 with SMTP id c11so1076942eaa.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 13:15:47 -0700 (PDT)
Message-ID: <504A55F0.2010406@gmail.com>
Date: Fri, 07 Sep 2012 22:15:44 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 13/28] Add V4L2_CAP_MONOTONIC_TS where applicable.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <753ddb14136b19372f3a533961fc90b5adbfb07a.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <753ddb14136b19372f3a533961fc90b5adbfb07a.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Add the new V4L2_CAP_MONOTONIC_TS capability to those drivers that
> use monotomic timestamps instead of the system time.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

For s5p-fimc,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
