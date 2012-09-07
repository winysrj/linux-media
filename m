Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41624 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2IGT6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 15:58:33 -0400
Received: by eekc1 with SMTP id c1so1417182eek.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 12:58:32 -0700 (PDT)
Message-ID: <504A51E5.6020502@gmail.com>
Date: Fri, 07 Sep 2012 21:58:29 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 03/28] DocBook: improve STREAMON/OFF documentation.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <133a249609e30bd0c77fcc12c01b8899f3ff81d7.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <133a249609e30bd0c77fcc12c01b8899f3ff81d7.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Specify that STREAMON/OFF should return 0 if the stream is already
> started/stopped.
>
> The spec never specified what the correct behavior is. This ambiguity
> was resolved during the 2012 Media Workshop.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Regards,
Sylwester
