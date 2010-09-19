Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab0ISFeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 01:34:09 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8J5Y9i5015780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 01:34:09 -0400
Message-ID: <4C959E98.2060409@redhat.com>
Date: Sun, 19 Sep 2010 02:24:40 -0300
From: Douglas Schilling Landgraf <dougsland@redhat.com>
Reply-To: dougsland@redhat.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH -hg] Warn user that driver is backported and might not
 work as expected
References: <4C938158.9020604@redhat.com>
In-Reply-To: <4C938158.9020604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Mauro Carvalho Chehab wrote:
> Since the migration to -git, less developers are using the -hg tree. Also, some
> changes are happening upstream that would require much more than just compiling
> the tree with an older version, to be sure that the backport won't break anything,
> like the removal of BKL.
> 
> As normal users might not be aware of those issues, and bug reports may be sent
> based on a backported tree, add some messages to warn about the usage of a
> backported experimental (unsupported) tree.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Applied, thanks!

Cheers
Douglas
