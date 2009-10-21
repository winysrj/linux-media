Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2552 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZJUWu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 18:50:28 -0400
Message-ID: <f20788054e5cee595da2a495be684c2e.squirrel@webmail.xs4all.nl>
In-Reply-To: <bfdeacfa0910200534k451fd6aald38c381006ca8312@mail.gmail.com>
References: <bfdeacfa0910200534k451fd6aald38c381006ca8312@mail.gmail.com>
Date: Thu, 22 Oct 2009 00:50:25 +0200
Subject: Re: GO7007 driver and ADS Tech DVD Xpress DX2
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mark Bidewell" <mark.bidewell@alumni.clemson.edu>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

> I am looking into adding the patches for the ADS Tech DVD Xpress DX2
> into the GO7007 driver.  But before I get too far I was wondering what
> the status of the driver was and the future plans?

Sadly I don't have access to my old mails at the moment, but it is
currently maintained by a company that is mostly focused on supporting
their own go7007 based hardware. Look for some mails on the go7007 topic
in the past three months. Due to some major internal i2c changes the
version in our staging directory did drop support for quite a few consumer
go7007-based capture boxes since nobody had the hardware (or time) to
actually test and fix those i2c modules. In addition, some of those
modules duplicated modules that already exist in the v4l tree and so the
go7007 driver needs more work to get it to the stage that it can be moved
from staging into a 'prime-time' place among the other v4l drivers.

> Also how does the
> kernel driver track with updates from sources such as
> go7007.imploder.org?

First time I've heard of this site! It would be great if someone could
actually do some work on this driver to get it out of the staging tree.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

