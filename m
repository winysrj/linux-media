Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37456 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1762571AbdLSMHw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 07:07:52 -0500
Date: Tue, 19 Dec 2017 14:07:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v4 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171219120749.6zqhgfcjqndgbwcp@valkosipuli.retiisi.org.uk>
References: <20171202213443.GC32301@azazel.net>
 <20171202221201.6063-1-jeremy@azazel.net>
 <20171202221201.6063-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171202221201.6063-2-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jeremy,

On Sat, Dec 02, 2017 at 10:11:59PM +0000, Jeremy Sowden wrote:
> The CSS API uses a lot of nested anonymous structs defined in object
> macros to assign default values to its data-structures.  These have been
> changed to use compound-literals and designated initializers to make
> them more comprehensible and less fragile.
> 
> The compound-literals can also be used in assignment, which means we can
> get rid of some temporary variables whose only purpose is to be
> initialized by one of these anonymous structs and then serve as the
> rvalue in an assignment expression.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

I don't think it's useful to change the struct definition macros only to
remove a large number of assigned fields in the next patch. How about
merging the two patches?

Please also start a new thread when re-posting a set.

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
