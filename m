Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:52250 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab3HGRoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 13:44:01 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Wed, 7 Aug 2013 17:43:56 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F054C632C1D@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <20130723222106.GB12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F053616A13A@server10.irisys.local>
 <51EF92AF.7040205@samsung.com>
 <20130726090646.GJ12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F054C632A50@server10.irisys.local>,<20130807093554.GE16719@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130807093554.GE16719@valkosipuli.retiisi.org.uk>
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It defines the exact size of the physical frame.  The JPEG data is padded to this size.  The size of the JPEG before it was padded is also written into the last word of the physical frame.


________________________________________
From: Sakari Ailus [sakari.ailus@iki.fi]
Sent: 07 August 2013 10:35
To: Thomas Vajzovic
Cc: Sylwester Nawrocki; Sylwester Nawrocki; linux-media@vger.kernel.org; Laurent Pinchart
Subject: Re: width and height of JPEG compressed images

Hi Tom,

Before replying the rest, let me first ask you a question. Does ExF define
the size of the image, or does it define its maximum size? I think that may
make a big difference here.

--
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
