Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58684 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751656Ab2HKPUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 11:20:05 -0400
Date: Sat, 11 Aug 2012 18:20:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: bjlockie@lockie.ca
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: boot slow down
Message-ID: <20120811151959.GL29636@valkosipuli.retiisi.org.uk>
References: <501DA203.7070800@lockie.ca>
 <20120805212054.GA29636@valkosipuli.retiisi.org.uk>
 <501F4A5B.1000608@lockie.ca>
 <20120807112742.GB29636@valkosipuli.retiisi.org.uk>
 <6ef5338940a90b4c8000594d546bf479.squirrel@lockie.ca>
 <32d7859a-ceda-442d-be67-f4f682a6e3b9@email.android.com>
 <48430fdf908e6481ae55103bd11b7cfe.squirrel@lockie.ca>
 <50218BD8.8040207@lockie.ca>
 <20120808082408.GE29636@valkosipuli.retiisi.org.uk>
 <18c22f6605c5aefbab8a42c4c0d3eca2.squirrel@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18c22f6605c5aefbab8a42c4c0d3eca2.squirrel@lockie.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 08, 2012 at 01:18:33PM -0400, bjlockie@lockie.ca wrote:
> 
> How hard would it be to get an official kernel option not to load firmware
> OR be able to set the timeout?

I think the right solution is that the failure of the user space program
that is expected to load the firmware is considered as such, so the error
could be returned by request_firmware() immediately. There could be reasons
why it behaves the way it does currently as I don't know the details.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
