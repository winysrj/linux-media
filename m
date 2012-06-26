Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62011 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2FZUkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:40:06 -0400
Received: by dady13 with SMTP id y13so393964dad.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:40:06 -0700 (PDT)
Date: Tue, 26 Jun 2012 13:40:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
Message-ID: <20120626204002.GB3885@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
 <1340739262-13747-4-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340739262-13747-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
> New udev-182 seems to be buggy: even when usermode is enabled, it
> insists on needing that probe would defer any firmware requests.
> So, drivers with firmware need to defer probe for the first
> driver's core request, otherwise an useless penalty of 30 seconds
> happens, as udev will refuse to load any firmware.

Shouldn't you fix udev, if it really is a problem here?  Papering over
userspace bugs in the kernel isn't usually a good thing to do, as odds
are, it will hit some other driver sometime, right?

greg k-h
