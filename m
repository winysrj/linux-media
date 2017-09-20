Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51669
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751378AbdITVQa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 17:16:30 -0400
Date: Wed, 20 Sep 2017 18:16:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/6] media: dvb_frontend: cleanup ioctl handling logic
Message-ID: <20170920181623.67816753@recife.lan>
In-Reply-To: <1446c8bb-4df9-299d-b565-afdbdada85f2@kernel.org>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
        <616ac8323cfe1041ad05e9610c87ee9c5e247811.1505827883.git.mchehab@s-opensource.com>
        <1446c8bb-4df9-299d-b565-afdbdada85f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Sep 2017 14:58:12 -0600
Shuah Khan <shuah@kernel.org> escreveu:

> > +	c->state = DTV_UNDEFINED;> +	err = dvb_frontend_handle_ioctl(file, cmd, parg);  
> 
> With this change, c->state value gets changed unconditionally before
> calling the ioctl.
> 
> dvb_frontend_ioctl_properties() has logic for c->state == DTV_TUNE.
> Is it safe to set change c->state here? I think it should be set
> only when cmd is != FE_SET_PROPERTY or FE_GET_PROPERTY??

It doesn't mind. c->state is used just for debugging purposes. One of the
patches I made got rid of it.



Thanks,
Mauro
