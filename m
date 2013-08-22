Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:54360 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3HVPlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 11:41:44 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: width and height of JPEG compressed images
Date: Thu, 22 Aug 2013 15:41:41 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F054C634E48@server10.irisys.local>
References: <51D876DF.90507@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F054C632C1D@server10.irisys.local>
 <20130821131736.GE20717@valkosipuli.retiisi.org.uk>
 <2547877.KEf7cs3vQZ@avalon>
In-Reply-To: <2547877.KEf7cs3vQZ@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 21 August 2013 14:29, Laurent Pinchart wrote:
> On Wednesday 21 August 2013 16:17:37 Sakari Ailus wrote:
>> On Wed, Aug 07, 2013 at 05:43:56PM +0000, Thomas Vajzovic wrote:
>>> It defines the exact size of the physical frame.  The JPEG data is
>>> padded to this size. The size of the JPEG before it was padded is
>>> also written into the last word of the physical frame.

That would require either using a custom pixel format and have userspace
reading the size from the buffer, or mapping the buffer in kernel space
and reading the size there. The latter is easier for userspace, but
might it hinder performances ?

I think it ought to be a custom format and handled in userspace,
otherwise the bridge driver would have to call a subdev function
each frame to get it to fix-up the used size each time, which is
quite ugly.

Regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
