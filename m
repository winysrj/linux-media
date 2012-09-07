Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51835 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2IGUSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 16:18:14 -0400
Received: by eekc1 with SMTP id c1so1426333eek.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 13:18:13 -0700 (PDT)
Message-ID: <504A5683.5020807@gmail.com>
Date: Fri, 07 Sep 2012 22:18:11 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 14/28] DocBook: clarify that sequence is also
 set for output devices.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <218a8f843734b9b2572842bc817ed36970931c24.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <218a8f843734b9b2572842bc817ed36970931c24.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> It was not entirely obvious that the sequence count should also
> be set for output devices. Also made it more explicit that this
> sequence counter counts frames, not fields.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

