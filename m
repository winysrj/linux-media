Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7BGiCtm007444
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 12:44:12 -0400
Received: from mail-yw0-f203.google.com (mail-yw0-f203.google.com
	[209.85.211.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7BGhwLX029131
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 12:43:59 -0400
Received: by ywh41 with SMTP id 41so5503589ywh.23
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 09:43:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b24e53350908110934q5ad0a3c6racdd656a2e002240@mail.gmail.com>
References: <b24e53350908110934q5ad0a3c6racdd656a2e002240@mail.gmail.com>
Date: Tue, 11 Aug 2009 12:43:58 -0400
Message-ID: <b24e53350908110943w6d91cenec9589686eddf410@mail.gmail.com>
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: V4L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Fwd: v4ldvb does not buildon CentOS 5.3 as of this morning...see
	e-mail contents...
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

---------- Forwarded message ----------
From: Robert Krakora <rob.krakora@messagenetsystems.com>
Date: Tue, Aug 11, 2009 at 12:34 PM
Subject: v4ldvb does not buildon CentOS 5.3 as of this morning...see e-mail
contents...
To: linux-media@vger.kernel.org


  CC [M]  /home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.o
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:48: warning:
initialization makes integer from pointer without a cast
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:48: error:
initializer element is not computable at load time
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:48: error: (near
initialization for 'si470x_i2c_id[0].id')
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:48: warning: excess
elements in struct initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:48: warning: (near
initialization for 'si470x_i2c_id[0]')
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:365: error: unknown
field 'probe' specified in initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:365: warning:
missing braces around initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:365: warning: (near
initialization for 'si470x_i2c_driver.list')
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:365: warning:
initialization from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:366: error: unknown
field 'remove' specified in initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:366: warning: excess
elements in struct initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:366: warning: (near
initialization for 'si470x_i2c_driver')
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:367: error: unknown
field 'id_table' specified in initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:367: warning: excess
elements in struct initializer
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.c:367: warning: (near
initialization for 'si470x_i2c_driver')
make[3]: *** [/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-i2c.o] Error
1
make[3]: *** Waiting for unfinished jobs....
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_set_chan':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:187: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:187: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:189: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:189: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_set_seek':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:323: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:323: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:325: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:325: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:328: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:328: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_queryctrl':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:462: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:462: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_g_ctrl':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:497: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:497: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_s_ctrl':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:536: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:536: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_g_tuner':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:640: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:640: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_s_tuner':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:679: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:679: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_g_frequency':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:709: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:709: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_s_frequency':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:738: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:738: error:
'struct class_device' has no member named 'bus_id'
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c: In function
'si470x_vidioc_s_hw_freq_seek':
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:767: warning:
passing argument 1 of 'dev_driver_string' from incompatible pointer type
/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.c:767: error:
'struct class_device' has no member named 'bus_id'
make[3]: *** [/home/silentm/MessageNet/v4l-dvb/v4l/radio-si470x-common.o]
Error 1
make[2]: *** [_module_/home/silentm/MessageNet/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.18-128.4.1.el5-x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/silentm/MessageNet/v4l-dvb/v4l'
make: *** [all] Error 2


-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax



-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
