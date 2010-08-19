Return-path: <mchehab@pedra>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40169 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750927Ab0HSJcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 05:32:53 -0400
Received: by wwb34 with SMTP id 34so1793717wwb.29
        for <linux-media@vger.kernel.org>; Thu, 19 Aug 2010 02:32:51 -0700 (PDT)
MIME-Version: 1.0
From: Martin Rubli <mrubligbox@gmail.com>
Date: Thu, 19 Aug 2010 17:25:10 +0800
Message-ID: <AANLkTikawoE4LpDUSxd8richdau4ySc63=AeNiJx2473@mail.gmail.com>
Subject: [RFC] Media controller addition: MEDIA_IOC_ENTITY_INFO
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi all,

Following some discussion with Laurent Pinchart I'd like to suggest
the addition of a new ioctl to the media controller API:
MEDIA_IOC_ENTITY_INFO.

The purpose of the ioctl is to allow applications to retrieve advanced
information on a given entity. There are two parts: a generic one and
a driver-specific one. The latter allows drivers to make
driver-specific entity information available to applications.

To mention one example: The UVC driver exposes a device's
units/terminals as entities. Each of these entities has a unit ID and
some particular units (extension units for vendor-specific controls)
have a GUID that uniquely identifies their interface. These two pieces
of information are very interesting for apps because it allows them to
generically access all these controls.

At the moment there isn't a lot of generic information in the
media_entity_info struct. Only a generic bus ID that can e.g. be used
to differentiate I2C chips. Suggestions for further generic fields are
welcome, and so is more general feedback.

Cheers,
Martin



	MEDIA_IOC_ENTITY_INFO - Obtain detailed information on a given entity
	---------------------------------------------------------------------

	ioctl(int fd, int request, struct media_entity_info *argp);

Applications can retrieve detailed information about a given entity using this
ioctl. This entity information contains both, a generic part, as well as a
driver specific part. While the size, fields, and format of the former one are
defined by the media kernel API the latter one is defined by the driver behind
the entity's device and can be of arbitrary size.

Querying the driver specific entity information is optional. To only query the
generic part the application sets drvinfo_size to 0 and drvinfo to NULL. The
function returns either success (if no driver specific information is available)
or ENOBUFS (if driver specific information would be available). In both cases
the generic entity information is properly returned.

In order to query the driver specific part the application sets drvinfo_size to
the correct size of the driver specific structure, and points drvinfo to a
pre-allocated structure of the same size.

To maintain maximum flexibility a method to query the size of the driver
specific entity information is provided. If the number provided in drvinfo_size
is smaller than the size of the driver specific structure the correct size is
stored in the drvinfo_size field and the function returns with ENOBUFS. The
drvinfo pointer is ignored in that case. Therefore the suggested way to query
all available entity information is as follows:

  1. Call the function with drvinfo_size set to 0 and drvinfo to NULL.
  2. Verify that the error code is ENOBUFS. In case of success, no driver
     specific information is available and the remaining steps can be skipped.
  3. Allocate a buffer of size drvinfo_size and point drvinfo to it.
  4. Call the function again.
  5. Verify that the return value indicates success.

Note for driver developers: Driver specific entity information structures are to
start with a header field of type media_entity_drvinfo.

The media_entity_info and related structures are defined as

- struct media_entity_drvinfo

__u32		magic		A magic number identifying the type of the
				structure.
__u8		data[0]		Driver specific data of arbitrary size.

The magic number allows for an application to verify that the type of the
obtained driver specific information indeed corresponds to what it expects to
process. Newer versions of a driver can use different magic numbers to indicate
that the data structure has changed. Drivers are free to choose the format of
the magic number.

- struct media_entity_info

__u32		entity		Entity id, set by the application.
char		bus_id[32]	A bus ID of undefined format.
__u32		reserved[8]	Reserved for future extensions.
__u32		drvinfo_size	Size of the data pointed to by 'drvinfo', set by
				both application and driver.
struct media_entity_drvinfo
		*drvinfo	A pointer to a pre-allocated structure of driver
				specific format, set by the application.

Return values:

  EINVAL	A parameter is invalid. This can indicate that the entity id is
		invalid or that the drvinfo pointer is NULL despite a correct
		drvinfo_size value.

  EFAULT	A pointer is invalid, either argp itself or the drvinfo field.

  ENOENT	There is no information available about the given entity.

  ENOBUFS	The buffer size specified in drvinfo_size is not big enough to
		hold the driver specific entity information structure. The
		correct size is being returned in drvinfo_size.
