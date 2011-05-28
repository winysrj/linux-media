Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1E1QUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 12:20:37 -0400
Message-ID: <4DE120D1.2020805@redhat.com>
Date: Sat, 28 May 2011 13:20:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105260853.31065.hverkuil@xs4all.nl> <4DE0E7D5.9070000@redhat.com> <201105281724.25433.hverkuil@xs4all.nl>
In-Reply-To: <201105281724.25433.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-05-2011 12:24, Hans Verkuil escreveu:
> But I would really like to see an RFC with a proposal of the API and how
> it is to be used. Then after an agreement has been reached the library can
> be modified accordingly and we can release it.

Ok, that's the RFC for the API. The code is already committed, on a separate
library at v4l-utils. So, feel free to test.

1) Media enumberation library
   ==========================

/**
 * enum device_type - Enumerates the type for each device
 *
 * The device_type is used to sort the media devices array.
 * So, the order is relevant. The first device should be
 * V4L_VIDEO.
 */
enum device_type {
	UNKNOWN = 65535,
	NONE    = 65534,
	V4L_VIDEO = 0,
	V4L_VBI,
	DVB_FRONTEND,
	DVB_DEMUX,
	DVB_DVR,
	DVB_NET,
	DVB_CA,
	/* TODO: Add dvb full-featured nodes */
	SND_CARD,
	SND_CAP,
	SND_OUT,
	SND_CONTROL,
	SND_HW,
};

/**
 * discover_media_devices() - Returns a list of the media devices
 * @md_size:	Returns the size of the media devices found
 *
 * This function reads the /sys/class nodes for V4L, DVB and sound,
 * and returns an opaque desciptor that keeps a list of the devices.
 * The fields on this list is opaque, as they can be changed on newer
 * releases of this library. So, all access to it should be done via
 * a function provided by the API. The devices are ordered by device,
 * type and node. At return, md_size is updated.
 */
void *discover_media_devices(void);

/**
 * free_media_devices() - Frees the media devices array
 *
 * @opaque:	media devices opaque descriptor
 *
 * As discover_media_devices() dynamically allocate space for the
 * strings, feeing the list requires also to free those data. So,
 * the safest and recommended way is to call this function.
 */
void free_media_devices(void *opaque);

/**
 * display_media_devices() - prints a list of media devices
 *
 * @opaque:	media devices opaque descriptor
 */
void display_media_devices(void *opaque);

/**
 * get_not_associated_device() - Return the next device not associated with
 * 				 an specific device type.
 *
 * @opaque:		media devices opaque descriptor
 * @last_seek:		last seek result. Use NULL to get the first result
 * @desired_type:	type of the desired device
 * @not_desired_type:	type of the seek device
 *
 * This function seeks inside the media_devices struct for the next physical
 * device that doesn't support a non_desired type.
 * This method is useful for example to return the audio devices that are
 * provided by the motherboard.
 */
char *get_associated_device(void *opaque,
			    char *last_seek,
			    enum device_type desired_type,
			    char *seek_device,
			    enum device_type seek_type);

			    /**
 * get_associated_device() - Return the next device associated with another one
 *
 * @opaque:		media devices opaque descriptor
 * @last_seek:		last seek result. Use NULL to get the first result
 * @desired_type:	type of the desired device
 * @seek_device:	name of the device with you want to get an association.
 *@ seek_type:		type of the seek device. Using NONE produces the same
 *			result of using NULL for the seek_device.
 *
 * This function seeks inside the media_devices struct for the next device
 * that it is associated with a seek parameter.
 * It can be used to get an alsa device associated with a video device. If
 * the seek_device is NULL or seek_type is NONE, it will just search for
 * devices of the desired_type.
 */
char *get_not_associated_device(void *opaque,
			    char *last_seek,
			    enum device_type desired_type,
			    enum device_type not_desired_type);

2) Example showing the typical usecase
   ===================================

#include "../libmedia_dev/get_media_devices.h"
#include <stdio.h>

int main(void)
{
	void *md;
	char *alsa;

	md = discover_media_devices();
	display_media_devices(md);

	alsa = get_associated_device(md, NULL, SND_CAP, "video0", V4L_VIDEO);
	if (alsa)
		printf("Alsa device associated with video0 capture: %s\n", alsa);

	alsa = get_not_associated_device(md, NULL, SND_OUT, V4L_VIDEO);
	if (alsa)
		printf("Alsa output device: %s\n", alsa);

	free_media_devices(md);

	return 0;
}

3) Planned improvements
   ====================

a) To create a new functions similar to get_associated_device, that uses an opened 
   file descriptor for device association;

b) provide a method to return /dev names for applications.

Cheers,
Mauro


