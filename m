Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42118 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbeDEKSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:18:36 -0400
Date: Thu, 5 Apr 2018 07:18:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 0/2] v4l-utils fixes
Message-ID: <20180405071830.44d330e5@vento.lan>
In-Reply-To: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  5 Apr 2018 13:00:38 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi folks,
> 
> The two patches add instructions for building static binaries as well as
> fix a few warnings in libdvb5.
> 
> Sakari Ailus (2):
>   Add instructions for building static binaries
>   libdvb5: Fix unused local variable warnings
> 
>  INSTALL                      | 16 ++++++++++++++++
>  lib/libdvbv5/dvb-dev-local.c |  5 +++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 

Both patches look ok on my eyes.


Thanks,
Mauro
