Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:41280 "EHLO
	rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2G3M7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 08:59:02 -0400
From: Konke Radlow <kradlow@cisco.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library  Signed-off-by: Konke Radlow <kradlow@cisco.com>
Date: Mon, 30 Jul 2012 14:46:09 +0000
Cc: linux-media@vger.kernel.org
References: <201207261621.26669.kradlow@cisco.com> <5013C828.9090307@redhat.com>
In-Reply-To: <5013C828.9090307@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207301446.09260.kradlow@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,
no need to thank me for working on it. First of all I do it as a part of a
summerjob, and more importantly I quite enjoy it and  intend to stay a active
member of the development process after my time at Cisco is over.

Thank you for your comments.

> Most fields in this struct (and in the other structs for that matter) could
> do with some more documentation.
I added a lot of short comments explaining the meaning of the fields, and
extended the explanation part that comes before each struct definition.

> > +   /** RDS info fields **/
> > +   bool is_rbds;           /* use RBDS standard version of LUTs */
> > +   uint16_t pi;
> > +   uint8_t ps[8];
>
> Looking at rds-ctl, this contains a string, please make it 9 bytes and
> always 0 terminate it! I also notice in rds-ctl that you filter the chars
> for being valid ascii and if not replace them with a space. Does the spec
> say anything about the encoding used for this string? Could we maybe
> convert it to UTF-8 inside the library so that apps can just consume the
> string?
The character encoding complies with ISO/IEC 10646, so it basically already is
UTF-8, and the data could be stored in a wchar_t array without conversion.
Is that preferred over uint8_t?

> > +/* adds a raw RDS block to decode it into RDS groups
> > + * @return:        bitmask with with updated fields set to 1
> > + * @rds_data:      3 bytes of raw RDS data, obtained by calling read()
> > + *                                 on RDS capable V4L2 devices */
> > +LIBV4L_PUBLIC uint32_t v4l2_rds_add(struct v4l2_rds *handle, struct
> > v4l2_rds_data *rds_data);
>
> Unless I'm missing something, you are no defining struct v4l2_rds_data
> anywhere, why not just make this a uint8_t ?
The v4l2_rds_data structure is defined by v4l in the videodev2.h header, and is
returned when calling the read function on a rds capable device
source: http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-rds-data
Maybe I didn't get you point though?

greetings,
Konke
