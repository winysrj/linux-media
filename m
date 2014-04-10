Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:53206 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661AbaDJO5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 10:57:00 -0400
Received: by mail-yk0-f170.google.com with SMTP id 9so3658391ykp.29
        for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 07:56:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <534675E1.6050408@sca-uk.com>
References: <534675E1.6050408@sca-uk.com>
Date: Thu, 10 Apr 2014 10:49:51 -0400
Message-ID: <CALzAhNVxFYm4J-ZUwFB5AeR0N__+BRHiCEGgyxcKgEPqfKNJ=g@mail.gmail.com>
Subject: Re: Hauppauge ImpactVCB-e 01385
From: Steven Toth <stoth@kernellabs.com>
To: Steve Cookson - IT <it@sca-uk.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> When I plug in my 01385 I get the same old stuff in dmseg, ie:
>
> cx23885 driver version 0.0.3 loaded
> [ 8.921390] cx23885[0]: Your board isn't known (yet) to the driver.
> [ 8.921390] cx23885[0]: Try to pick one of the existing card configs via
> [ 8.921390] cx23885[0]: card=<n> insmod option. Updating to the latest
> [ 8.921390] cx23885[0]: version might help as well.
> [ 8.921393] cx23885[0]: Here is a list of valid choices for the card=<n>
> insmod option:
>
> Etc.
>
> Does anyone have any idea of the issue here?

Sure. The issue is nobody cares enough to update the driver to support
your card and make it work out of the box.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
