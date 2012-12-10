Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4692 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2LJXVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 18:21:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: andrea <mariofutire@googlemail.com>
Subject: Re: Understanding v4l2-ctl flags
Date: Tue, 11 Dec 2012 00:20:32 +0100
Cc: linux-media@vger.kernel.org
References: <ka5jci$q8q$1@ger.gmane.org>
In-Reply-To: <ka5jci$q8q$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212110020.32055.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon December 10 2012 22:14:59 andrea wrote:
> Hi,
> 
> I have a Logitech webcam under PWC.
> I've managed to use v4l2-ctl to change come controls, but some of them seem to be unsupported.
> 
> v4l2-ctl reports the following flags
> 
> inactive
> update
> slider
> write-only
> ** no flags at all **
> 
> e.g.
> 
> restore_factory_settings (button) : flags=update, write-only
> 
> What is the meaning of them?
> I can guess that inactive means unsupported, but do I care about the others?

See the documentation for control flags:

http://hverkuil.home.xs4all.nl/spec/media.html#control-flags

'inactive' doesn't mean unsupported, it just means that setting the control
probably will have no effect at the moment. E.g. setting the gain when autogain
is selected doesn't do anything. Only when the autogain is turned off can you
set the gain control.

Regards,

	Hans
