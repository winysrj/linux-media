Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:49393 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCEBdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 20:33:41 -0500
Received: by ewy25 with SMTP id 25so2879659ewy.37
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 17:33:38 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Wed, 4 Mar 2009 19:33:29 -0600
Cc: kilgota@banach.math.auburn.edu,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <200903032050.13915.elyk03@gmail.com> <49AE3E2F.70905@redhat.com>
In-Reply-To: <49AE3E2F.70905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041933.29491.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 March 2009 02:39:11 Hans de Goede wrote:
> Which also makes me wonder about the same change for the mr97310a, is that
> cam already supported in a released kernel ?
>
> If not we MUST make sure we get this change in before 2.6.29 final, if it
> is I'm afraid we cannot make these changes. In that case if we ever need to
> header data we need to define a new PIXFMT for mr97310a with the header
> data, and deprecate the old one.
>

I don't believe the driver has made it to any kernel yet.  Even if it has, the 
user would need to have an unreleased version of libv4l.  I think this change 
would inconvenience me and Theodore at most.  Let's change it now.

-Kyle
