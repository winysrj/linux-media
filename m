Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37377 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbaCZNdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 09:33:02 -0400
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH v4 00/10] media: rc: ImgTec IR decoder driver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Mar 2014 14:33:00 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
In-Reply-To: <53329DD2.3080105@imgtec.com>
References: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com>
 <20140325235314.GB2515@hardeman.nu> <53329DD2.3080105@imgtec.com>
Message-ID: <bf67572bc16fc746f2a21c2a6e7fa622@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-03-26 10:28, James Hogan wrote:
> On 25/03/14 23:53, David Härdeman wrote:
>> One thing I just noticed...your copyright headers throughout the 
>> driver
>> seems a bit...sparse? :)
> 
> True, I can add the basic:
...
> to each of the files if you think it's necessary.

I think doing so for each *.c file would be a very good idea (and the 
*.h files if they are complicated enough), but I'm not the maintainer, 
so I can't tell you what to do :)

//David
