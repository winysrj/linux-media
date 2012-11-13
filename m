Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2KMTT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 14:19:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TYM1H-0005Km-LN
	for linux-media@vger.kernel.org; Tue, 13 Nov 2012 20:19:35 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 20:19:35 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 20:19:35 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Color problem with MPX-885 card (cx23885)
Date: Tue, 13 Nov 2012 20:19:13 +0100
Message-ID: <k7u6ff$5nf$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org> <CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com> <k7tt38$aol$1@ger.gmane.org> <CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com> <k7u1vf$q5h$1@ger.gmane.org> <CAGoCfiwNxh6uNXaQLNO7r4e8PXZxQ0+jZGY0ZjzXdy2vbmG-NA@mail.gmail.com> <k7u5id$si8$1@ger.gmane.org> <CAGoCfizTJXViw4p3kMMg1jaHgSYWDcONC9QVYpkfZ7YDZ2zpuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAGoCfizTJXViw4p3kMMg1jaHgSYWDcONC9QVYpkfZ7YDZ2zpuQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.11.2012 20:12, schrieb Devin Heitmueller:
> Just to be clear, I wasn't intending to suggest that you were using
> any of the actual V4L2 cropping features.  I'm just saying that if the
> video scaler were broken, it's possible that the frames are
> *effectively* being cropped at 640x480.

Absolutely, you found the problem. Thanks a lot. Indeed as soon as I
define a resolution (even the 640x480) I get the full picture. Only if
NO resolution is specified, I get 640x480 as a croped version.

Funny bug. For me I can live with the current solution. I can define the
resolution with mplayer and crop out the black left border. (Hopefully
QTMultimedia can do that also...)

Again, you have been very helpful. Thank you very very much.

Michael

> 
> But yeah, you should definitely try capturing at 720x576 in mplayer.
> You can specific command line arguments to mplayer to set the width
> and height.
> 
> Devin
> 


