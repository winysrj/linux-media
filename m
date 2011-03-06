Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:46968 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1CFR6D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Mar 2011 12:58:03 -0500
Date: Sun, 6 Mar 2011 18:57:13 +0100
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Oliver Neukum <oliver@neukum.org>,
	Jack Stone <jwjstone@fastmail.fm>
Subject: Re: [PATCH 1/2 v3] [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110306185713.5b621e80@schatten.dmk.lab>
In-Reply-To: <1299433677-8269-1-git-send-email-florian@mickler.org>
References: <201103061744.15946.oliver@neukum.org>
	<1299433677-8269-1-git-send-email-florian@mickler.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun,  6 Mar 2011 18:47:56 +0100
Florian Mickler <florian@mickler.org> wrote:


> +static void dib0700_disconnect(struct usb_interface *intf) {


That { should go on its own line... sorry ;-)

If that patch is acceptable, I can resend with that fixed. 

Regards,
Flo
