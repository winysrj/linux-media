Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:62073 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbcGMKKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:10:31 -0400
Subject: Re: [PATCH 2/2] doc-rst: improve CEC documentation
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1468346865-36465-1-git-send-email-hverkuil@xs4all.nl>
 <1468346865-36465-3-git-send-email-hverkuil@xs4all.nl>
 <20160713070627.1c2368d6@recife.lan>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <5786138F.5050103@cisco.com>
Date: Wed, 13 Jul 2016 12:10:23 +0200
MIME-Version: 1.0
In-Reply-To: <20160713070627.1c2368d6@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/16 12:06, Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Tue, 12 Jul 2016 20:07:45 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Lots of fixups relating to references.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/media/uapi/cec/cec-func-ioctl.rst    |  2 +-
>>  Documentation/media/uapi/cec/cec-func-open.rst     | 10 +++----
>>  .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 18 ++++++------
>>  .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 14 ++++-----
>>  .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    | 14 ++++-----
>>  Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  2 +-
>>  Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 34 +++++++++-------------
>>  Documentation/media/uapi/cec/cec-ioc-receive.rst   | 28 +++++++++---------
>>  8 files changed, 58 insertions(+), 64 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
>> index a07cc7c..d0279e6d 100644
>> --- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
>> +++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
>> @@ -29,7 +29,7 @@ Arguments
>>  
>>  ``request``
>>      CEC ioctl request code as defined in the cec.h header file, for
>> -    example CEC_ADAP_G_CAPS.
>> +    example :ref:`CEC_ADAP_G_CAPS`.
>>  
>>  ``argp``
>>      Pointer to a request-specific structure.
>> diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
>> index 245d679..cbf1176 100644
>> --- a/Documentation/media/uapi/cec/cec-func-open.rst
>> +++ b/Documentation/media/uapi/cec/cec-func-open.rst
>> @@ -32,11 +32,11 @@ Arguments
>>      Open flags. Access mode must be ``O_RDWR``.
>>  
>>      When the ``O_NONBLOCK`` flag is given, the
>> -    :ref:`CEC_RECEIVE` ioctl will return EAGAIN
>> -    error code when no message is available, and the
>> -    :ref:`CEC_TRANSMIT`,
>> -    :ref:`CEC_ADAP_S_PHYS_ADDR` and
>> -    :ref:`CEC_ADAP_S_LOG_ADDRS` ioctls
>> +    :ref:`CEC_RECEIVE <CEC_RECEIVE>` ioctl will return the EAGAIN
>> +    error code when no message is available, and ioctls
>> +    :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`,
>> +    :ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` and
>> +    :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
>>      all act in non-blocking mode.
>>  
>>      Other flags have no effect.
>> diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
>> index 2ca9199..63b808e 100644
>> --- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
>> +++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
>> @@ -34,7 +34,7 @@ Description
>>  .. note:: This documents the proposed CEC API. This API is not yet finalized
>>     and is currently only available as a staging kernel module.
>>  
>> -All cec devices must support the :ref:`CEC_ADAP_G_CAPS` ioctl. To query
>> +All cec devices must support ``CEC_ADAP_G_CAPS``. To query
> 
> Why are you removing the ref here and on other similar places? If you
> remove it, the font and font color for it will be different and
> inconsistent. It will also be inconsistent with the other places
> within the document, were it is using a reference everywhere.

What's the point of having a link to the same page that you are watching?
I also found it very cumbersome and ugly having to write e.g.

:ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>

all the time. That is fine if it actually points to another page (it serves a
real purpose then), but on the page itself I think it is ugly. We never did
that with the DocBook documentation either.

Regards,

	Hans
