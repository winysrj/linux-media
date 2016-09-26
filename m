Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38619 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932426AbcIZJSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 05:18:35 -0400
Date: Mon, 26 Sep 2016 12:18:31 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
Message-ID: <20160926091831.cp6qkv77oo5tinn5@zver>
References: <20160915130441.ji3f3jiiebsnsbct@acer>
 <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
 <m3k2e5wfxy.fsf@t19.piap.pl>
 <20160921134554.s3tdolyej6r2w5wh@zver>
 <m360powc4m.fsf@t19.piap.pl>
 <20160922152356.nhgacxprxtvutb67@zver>
 <m3ponri5ky.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3ponri5ky.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 26, 2016 at 07:38:05AM +0200, Krzysztof Hałasa wrote:
> Andrey Utkin <andrey_utkin@fastmail.com> writes:
> 
> > On Thu, Sep 22, 2016 at 10:51:37AM +0200, Krzysztof Hałasa wrote:
> >> I wonder if the following fixes the problem (completely untested).
> >
> > I have given this a run, and it still hangs.
> 
> Does (only) adding the
> 
> 	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
> 
> in solo_reg_write() help?

Yes.
I have posted a patch with this change few days ago, I thought you have
noticed it.
