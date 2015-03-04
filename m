Return-path: <linux-media-owner@vger.kernel.org>
Received: from or-71-0-52-80.sta.embarqhsd.net ([71.0.52.80]:58495 "EHLO
	asgard.dharty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbbCDDm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 22:42:58 -0500
Message-ID: <54F67F3E.4050708@dharty.com>
Date: Tue, 03 Mar 2015 19:42:54 -0800
From: catchall <catchall@dharty.com>
Reply-To: v4l@dharty.com
MIME-Version: 1.0
To: Brendan McGrath <redmcg@redmandi.dyndns.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
CC: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCHv3] [media] saa7164: use an MSI interrupt when available
References: <54EFAC4B.6080002@redmandi.dyndns.org> <1425168893-5251-1-git-send-email-redmcg@redmandi.dyndns.org>
In-Reply-To: <1425168893-5251-1-git-send-email-redmcg@redmandi.dyndns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/28/2015 04:14 PM, Brendan McGrath wrote:
> Enhances driver to use an MSI interrupt when available.
>
> Adds the module option 'enable_msi' (type bool) which by default is
> enabled. Can be set to 'N' to disable.
>
> Fixes (or can reduce the occurrence of) a crash which is most commonly
> reported when multiple saa7164 chips are in use. A reported example can
> be found here:
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/83948
>
> Reviewed-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>
>
I wanted to report that I have been running this patch for about a week 
now and I have had no instances of the zero free sequences issue.

Thank you very much!

David

