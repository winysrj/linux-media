Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35069
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752563AbcLHPPw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 10:15:52 -0500
Date: Thu, 8 Dec 2016 13:15:44 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Felipe Sanches <juca@members.fsf.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.11] Remove FSF postal address
Message-ID: <20161208131544.2d6609dc@vento.lan>
In-Reply-To: <20161208144728.GH16630@valkosipuli.retiisi.org.uk>
References: <20161208080825.GB16630@valkosipuli.retiisi.org.uk>
        <CAK6XL6DaXaf=dxU20BpyVqW_UxaFOfTGtVO6MppvPuZxa9puMA@mail.gmail.com>
        <20161208110920.GG16630@valkosipuli.retiisi.org.uk>
        <20161208105947.3f4fa3aa@vento.lan>
        <20161208144728.GH16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 8 Dec 2016 16:47:28 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> > Ok, if you're doing massive changes on some driver, be my
> > guest and remove the FSF address from it. Otherwise, just live
> > it as-is.  
> 
> This is a cleanup. The patch removes 628 instances of the postal address of
> which 578 are outdated:

Ok, that's a good enough reason to remove it. Please add it at the
patch's description, and I'll apply for 4.11, after the merge window.

Regards,
Mauro
